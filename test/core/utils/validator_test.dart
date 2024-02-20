import 'package:test/test.dart';
import 'package:gemi/core/utils/validator.dart';

void main() {
  group('Validator', () {
    group('validateEmail', () {
      test('should return null for valid email', () {
        // Arrange
        const email = 'test@example.com';

        // Act
        final result = Validator.validateEmail(email);

        // Assert
        expect(result, null);
      });

      test('should return "Email is required" for empty email', () {
        // Arrange
        const email = '';

        // Act
        final result = Validator.validateEmail(email);

        // Assert
        expect(result, 'Email is required');
      });

      test('should return "Please enter a valid email" for invalid email', () {
        // Arrange
        const email = 'invalidemail';

        // Act
        final result = Validator.validateEmail(email);

        // Assert
        expect(result, 'Please enter a valid email');
      });
    });

    group('validatePassword', () {
      test('should return null for valid password', () {
        // Arrange
        const password = 'password123';

        // Act
        final result = Validator.validatePassword(password);

        // Assert
        expect(result, null);
      });

      test('should return "Password is required" for empty password', () {
        // Arrange
        const password = '';

        // Act
        final result = Validator.validatePassword(password);

        // Assert
        expect(result, 'Password is required');
      });

      test(
          'should return "Password must be at least 6 characters" for short password',
          () {
        // Arrange
        const password = 'pass';

        // Act
        final result = Validator.validatePassword(password);

        // Assert
        expect(result, 'Password must be at least 6 characters');
      });
    });
  });
}
