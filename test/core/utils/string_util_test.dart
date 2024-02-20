import 'package:test/test.dart';
import 'package:gemi/core/utils/string_util.dart';

void main() {
  group('StringUtil', () {
    test('isValidEmail should return true for valid email', () {
      // Arrange
      final email = 'test@example.com';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, true);
    });

    test('should return false for email without @', () {
      // Arrange
      final email = 'invalidemail.com';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for empty email', () {
      // Arrange
      final email = '';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for email without domain', () {
      // Arrange
      final email = 'invalidemail@';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });

    test('isValidEmail should return false for invalid email', () {
      // Arrange
      final email = 'invalidemail';

      // Act
      final result = StringUtil.isValidEmail(email);

      // Assert
      expect(result, false);
    });
  });
}
