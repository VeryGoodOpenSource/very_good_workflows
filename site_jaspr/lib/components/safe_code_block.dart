import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:syntax_highlight_lite/syntax_highlight_lite.dart' hide Color;

/// A code block that renders syntax-highlighted code in **both** light and
/// dark themes at server-render time, toggling visibility via CSS.
///
/// Docusaurus uses `prism-react-renderer` with:
///   - light: vsLight  →  [HighlighterTheme.loadLightTheme()] (Light VS + Light+)
///   - dark:  vsDark   →  [HighlighterTheme.loadDarkTheme()]  (Dark VS + Dark+)
///
/// Both [pre] elements are emitted into the HTML; CSS hides the inactive one:
///   `.syntax-dark  { display: none }`
///   `[data-theme="dark"] .syntax-light { display: none }`
///   `[data-theme="dark"] .syntax-dark  { display: block }`
///
/// Falls back to [CodeBlock.from] (plain, no highlighting) for any language
/// not in [grammars].
class SafeCodeBlock extends CustomComponent {
  SafeCodeBlock({this.grammars = const {}}) : super.base();

  final Map<String, String> grammars;

  bool _initialized = false;
  HighlighterTheme? _lightTheme;
  HighlighterTheme? _darkTheme;

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node
        case ElementNode(tag: 'Code' || 'CodeBlock', :final children, :final attributes) ||
            ElementNode(
              tag: 'pre',
              children: [ElementNode(tag: 'code', :final children, :final attributes)],
            )) {
      var language = attributes['language'];
      if (language == null && (attributes['class']?.startsWith('language-') ?? false)) {
        language = attributes['class']!.substring('language-'.length);
      }

      if (!_initialized) {
        Highlighter.initialize(['dart']);
        for (final entry in grammars.entries) {
          Highlighter.addLanguage(entry.key, entry.value);
        }
        _initialized = true;
      }

      final source = children?.map((c) => c.innerText).join(' ') ?? '';

      // Fall back to plain (unhighlighted) rendering for unsupported languages.
      if (language != null && !_supportedLanguages.contains(language)) {
        return CodeBlock.from(source: source);
      }

      return AsyncBuilder(
        builder: (context) async {
          _lightTheme ??= await HighlighterTheme.loadLightTheme();
          _darkTheme ??= await HighlighterTheme.loadDarkTheme();

          final lang = language ?? 'dart';
          return _DualCodeBlock(
            source: source,
            lightHighlighter: Highlighter(language: lang, theme: _lightTheme!),
            darkHighlighter: Highlighter(language: lang, theme: _darkTheme!),
          );
        },
      );
    }
    return null;
  }

  Set<String> get _supportedLanguages => {'dart', ...grammars.keys};

  @css
  static List<StyleRule> get styles => [
    // Light theme visible by default; dark theme hidden.
    css('.syntax-dark').styles(display: Display.none),
    // Swap in dark mode.
    css('[data-theme="dark"] .syntax-light').styles(display: Display.none),
    css('[data-theme="dark"] .syntax-dark').styles(display: Display.block),
  ];
}

/// Emits two [pre] blocks (one per theme) inside a `.code-block` wrapper.
/// CSS decides which is shown based on `[data-theme]`.
class _DualCodeBlock extends StatelessComponent {
  const _DualCodeBlock({
    required this.source,
    required this.lightHighlighter,
    required this.darkHighlighter,
  });

  final String source;
  final Highlighter lightHighlighter;
  final Highlighter darkHighlighter;

  @override
  Component build(BuildContext context) {
    return div(classes: 'code-block', [
      pre(classes: 'syntax-light', [
        code([_buildSpan(lightHighlighter.highlight(source))]),
      ]),
      pre(classes: 'syntax-dark', [
        code([_buildSpan(darkHighlighter.highlight(source))]),
      ]),
    ]);
  }

  /// Converts a [TextSpan] tree from the highlighter into jaspr [Component]s
  /// with inline styles — mirrors `_CodeBlock.buildSpan` from jaspr_content.
  static Component _buildSpan(TextSpan textSpan) {
    Styles? styles;

    if (textSpan.style case final style?) {
      styles = Styles(
        color: Color.value(style.foreground.argb & 0x00FFFFFF),
        fontWeight: style.bold ? FontWeight.bold : null,
        fontStyle: style.italic ? FontStyle.italic : null,
        textDecoration: style.underline
            ? TextDecoration(line: TextDecorationLine.underline)
            : null,
      );
    }

    if (styles == null && textSpan.children.isEmpty) {
      return Component.text(textSpan.text ?? '');
    }

    return span(styles: styles, [
      if (textSpan.text != null) Component.text(textSpan.text!),
      for (final child in textSpan.children) _buildSpan(child),
    ]);
  }
}
