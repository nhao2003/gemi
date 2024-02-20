import 'package:test/test.dart';
import 'package:gemi/core/utils/mutex.dart';

void main() {
  group('Mutex', () {
    test('should acquire and release lock', () async {
      // Arrange
      final mutex = Mutex();

      // Act
      final lock = await mutex.acquire();

      // Assert
      expect(mutex.isLocked, true);

      // Release the lock
      lock.release();
      expect(mutex.isLocked, false);
    });

    test('should acquire locks in order', () async {
      // Arrange
      final mutex = Mutex();
      final lock1 = await mutex.acquire();

      // Act
      final lock2Future = mutex.acquire();

      // Assert
      expect(mutex.isLocked, true);

      // Release the first lock
      lock1.release();
      expect(mutex.isLocked, true);

      // Release the second lock
      final lock2 = await lock2Future;
      lock2.release();
      expect(mutex.isLocked, false);
    });

    test('should not allow releasing a released lock', () async {
      // Arrange
      final mutex = Mutex();
      final lock = await mutex.acquire();
      lock.release();

      // Act & Assert
      expect(() => lock.release(), throwsStateError);
    });
  });
}
