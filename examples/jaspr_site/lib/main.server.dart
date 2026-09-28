/// The entrypoint for the **server** environment.
///
/// The [main] method will only be executed on the server during pre-rendering.
/// To run code on the client, check the `main.client.dart` file.
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';
import 'package:jaspr_site/app.dart';
import 'package:jaspr_site/main.server.options.dart';

void main() {
  // Initializes the server environment with the generated default options.
  Jaspr.initializeApp(options: defaultServerOptions);

  // Starts the app by rendering the root document structure.
  runApp(
    Document(
      title: 'jaspr_site',
      styles: [
        css('html, body').styles(
          width: 100.percent,
          minHeight: 100.vh,
          padding: Padding.zero,
          margin: Margin.zero,
        ),
      ],
      body: const App(),
    ),
  );
}
