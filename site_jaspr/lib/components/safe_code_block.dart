import 'package:jaspr/server.dart';
import 'package:jaspr_content/components/code_block.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:syntax_highlight_lite/syntax_highlight_lite.dart' hide Color;

/// A code block component that falls back to plain text rendering
/// for languages not supported by the syntax highlighter.
///
/// Currently only 'dart' is supported for highlighting.
class SafeCodeBlock extends CustomComponent {
  SafeCodeBlock() : super.base();

  static const _supportedLanguages = {'dart'};

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
        _initialized = true;
      }

      if (language != null && !_supportedLanguages.contains(language)) {
        // Unsupported language: render as plain code block.
        final source = children?.map((c) => c.innerText).join(' ') ?? '';
        return CodeBlock.from(source: source);
      }

      return AsyncBuilder(
        builder: (context) async {
          final highlighter = Highlighter(
            language: language ?? 'dart',
            theme: _theme ??= await HighlighterTheme.loadDarkTheme(),
          );
          final source = children?.map((c) => c.innerText).join(' ') ?? '';
          return CodeBlock.from(source: source, highlighter: highlighter);
        },
      );
    }
    return null;
  }
}
