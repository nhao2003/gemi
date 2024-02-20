import 'package:test/test.dart';
import 'package:gemi/core/optional.dart';

void main() {
  group('Optional', () {
    test('Creating an Optional with a non-null value', () {
      const optional = Optional(1);
      expect(optional.isPresent, true);
      expect(optional.value, 1);
    });

    test('Creating an empty Optional', () {
      const optional = Optional.empty();
      expect(optional.isPresent, false);
      expect(optional.value, null);
    });

    test('Getting the value of an Optional', () {
      const optional = Optional(1);
      expect(optional.value, 1);
    });

    test('Getting the value of an empty Optional', () {
      const optional = Optional.empty();
      expect(optional.value, null);
    });

    test('Applying a mapping function to a non-null value', () {
      const optional = Optional(1);
      final result = optional.map((value) => value + 1);
      expect(result.isPresent, true);
      expect(result.value, 2);
    });

    test('Applying a mapping function to an empty Optional', () {
      const optional = Optional.empty();
      final result = optional.map((value) => value + 1);
      expect(result.isPresent, false);
      expect(result.value, null);
    });

    test('Getting the value of an Optional or else a default value', () {
      const optional = Optional(1);
      final result = optional.getOrElse(0);
      expect(result, 1);
    });

    test('Getting the value of an empty Optional or else a default value', () {
      const optional = Optional.empty();
      final result = optional.getOrElse(0);
      expect(result, 0);
    });

    test("Getting null value of an Optional or else a default value", () {
      const optional = Optional<bool?>(null);
      final result = optional.getOrElse(true);
      expect(result, null);
    });
  });
}
