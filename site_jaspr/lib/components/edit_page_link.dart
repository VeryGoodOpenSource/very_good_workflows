import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

/// "Edit this page" link shown below doc content, matching Docusaurus exactly.
///
/// Replicates the behavior of Docusaurus's [EditThisPage] component +
/// [EditMetaRow] wrapper, using the same editUrl base from docusaurus.config.js:
///   https://github.com/VeryGoodOpenSource/very_good_workflows/tree/main/site
///
/// The SVG pencil icon is the exact path from Docusaurus's Icon/Edit/index.tsx
/// (40×40 viewBox, fill="currentColor").
class EditPageLink extends StatelessComponent {
  const EditPageLink({super.key});

  static const _editUrlBase = 'https://github.com/VeryGoodOpenSource/very_good_workflows/tree/main/site';

  @override
  Component build(BuildContext context) {
    // This component is server-rendered only; context.page is not available
    // on the client.
    if (kIsWeb) return Component.fragment([]);

    final url = context.page.url;
    // Only render on /docs/* pages, but not the workflows category index.
    if (!url.startsWith('/docs/') || url == '/docs/workflows') return Component.fragment([]);

    // /docs/workflows/license_check  →  docs/workflows/license_check.md
    final filePath = '${url.replaceFirst('/', '')}.md';
    final editUrl = '$_editUrlBase/$filePath';

    return div(classes: 'edit-page-row', [
      a(
        href: editUrl,
        classes: 'edit-page-link theme-edit-this-page',
        attributes: {
          'target': '_blank',
          'rel': 'noopener noreferrer',
        },
        [
          // Exact SVG from Docusaurus packages/docusaurus-theme-classic/
          //   src/theme/Icon/Edit/index.tsx
          // viewBox="0 0 40 40", fill="currentColor" (filled pencil)
          svg(
            width: 20.px,
            height: 20.px,
            viewBox: '0 0 40 40',
            attributes: {
              'fill': 'currentColor',
              'aria-hidden': 'true',
            },
            [
              path(
                d: 'm34.5 11.7l-3 3.1-6.3-6.3 3.1-3q0.5-0.5 1.2-0.5t1.1 0.5l3.9 3.9q0.5 0.4 0.5 1.1t-0.5 1.2z m-29.5 17.1l18.4-18.5 6.3 6.3-18.4 18.4h-6.3v-6.2z',
                [],
              ),
            ],
          ),
          Component.text('Edit this page'),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
    // Block container — provides the 3rem top margin gap from content,
    // matching Docusaurus's `docusaurus-mt-lg` class on DocItemFooter.
    css('.edit-page-row').styles(
      margin: Margin.only(top: 1.75.rem),
    ),

    // The link itself: inline-flex so icon and text sit side by side.
    // color matches Infima's --ifm-link-color = var(--ifm-color-primary).
    css('.edit-page-link').styles(
      display: Display.inlineFlex,
      alignItems: AlignItems.center,
      color: Color('var(--primary)'),
      textDecoration: TextDecoration.none,
      raw: {'gap': '0.3em'},
    ),
    css('.edit-page-link:hover').styles(
      textDecoration: TextDecoration(line: TextDecorationLine.underline),
    ),

    // Prevent the SVG from growing/shrinking inside the flex row.
    css('.edit-page-link svg').styles(
      flex: Flex(shrink: 0),
    ),
  ];
}
