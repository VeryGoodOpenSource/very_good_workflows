import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:syntax_highlight_lite/syntax_highlight_lite.dart' hide Color;

/// A code block component that gracefully handles unsupported languages
/// by falling back to plain text rendering.
class SafeCodeBlock extends CustomComponent {
  SafeCodeBlock({this.grammars = const {}}) : super.base();

  final Map<String, String> grammars;

  bool _initialized = false;
  HighlighterTheme? _theme;

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

      // Fall back to plain rendering for unsupported languages.
      if (language != null && !_supportedLanguages.contains(language)) {
        return CodeBlock.from(source: source);
      }

      return AsyncBuilder(
        builder: (context) async {
          final highlighter = Highlighter(
            language: language ?? 'dart',
            theme: _theme ??= await HighlighterTheme.loadDarkTheme(),
          );
          return CodeBlock.from(source: source, highlighter: highlighter);
        },
      );
    }
    return null;
  }

  Set<String> get _supportedLanguages => {'dart', ...grammars.keys};
}
