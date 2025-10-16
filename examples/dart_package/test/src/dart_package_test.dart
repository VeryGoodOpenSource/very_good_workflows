// Can cause false positives.
// ignore_for_file: prefer_const_constructors
import 'package:dart_package/dart_package.dart';
import 'package:test/test.dart';

void main() {
  group(DartPackage, () {
    test('can be instantiated', () {
      expect(DartPackage(), isNotNull);
    });
  });
}
