/// The entrypoint for the **client** environment.
///
/// The [main] method will only be executed on the client when loading the page.
/// To run code on the server during pre-rendering, check `main.server.dart`.
library;

import 'package:jaspr/client.dart';
import 'package:jaspr_site/main.client.options.dart';

void main() {
  // Initializes the client environment with the generated default options.
  Jaspr.initializeApp(options: defaultClientOptions);

  // Loads and renders all components annotated with `@client`.
  runApp(const ClientApp());
}
