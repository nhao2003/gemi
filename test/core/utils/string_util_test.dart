import 'package:test/test.dart';
import 'package:gemi/core/utils/string_util.dart';

void main() {
  group('StringUtil.isValidEmail', () {
    test('isValidEmail should return true for valid email', () {
      // Arrange
      const email = 'test@example.com';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, true);
    });

    test('should return false for email without @', () {
      // Arrange
      const email = 'invalidemail.com';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for empty email', () {
      // Arrange
      const email = '';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for email without domain', () {
      // Arrange
      const email = 'invalidemail@';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for invalid email', () {
      // Arrange
      const email = 'invalidemail';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });
  });

  group('StringUtil.isURL', () {
    test('isURL should return true for valid URL', () {
      // Arrange
      const url = 'https://example.com';

      // Act
      final result = StringUtil.isURL(url);

      // Assert
      expect(result, true);
    });

    test('isURL should return false for invalid URL', () {
      // Arrange
      const url = 'invalidurl';

      // Act
      final result = StringUtil.isURL(url);

      // Assert
      expect(result, false);
    });

    test('isURL should return false for empty URL', () {
      // Arrange
      const url = '';

      // Act
      final result = StringUtil.isURL(url);

      // Assert
      expect(result, false);
    });

    test('isURL should return true for URL without protocol', () {
      // Arrange
      const url = 'example.com';

      // Act
      final result = StringUtil.isURL(url);

      // Assert
      expect(result, true);
    });
  });
}
