// Can cause false positives.
// ignore_for_file: prefer_const_constructors
import 'package:flutter_package/flutter_package.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(FlutterPackage, () {
    test('can be instantiated', () {
      expect(FlutterPackage(), isNotNull);
    });
  });
}
