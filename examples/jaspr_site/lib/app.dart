import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// The main component of the application.
///
/// By using the `@client` annotation this component is automatically compiled
/// to JavaScript and mounted on the client.
@client
class App extends StatelessComponent {
  /// Creates the main [App] component.
  // The lint's fix rewrites this to `const new(...)`, which requires the
  // experimental `primary-constructors` feature that `jaspr build` does not
  // enable, so it is suppressed here.
  // ignore: unnecessary_type_name_in_constructor
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return const section([
      h1([Component.text('Welcome')]),
      p([Component.text('You successfully created a new Jaspr site.')]),
    ]);
  }

  /// Defines the CSS styles for this component.
  @css
  static List<StyleRule> get styles => [
    css('section').styles(
      display: Display.flex,
      height: 100.vh,
      flexDirection: FlexDirection.column,
      justifyContent: JustifyContent.center,
      alignItems: AlignItems.center,
    ),
  ];
}
