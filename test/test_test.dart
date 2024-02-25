import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

abstract class TestMethod {
  Future<int> getInt(String key);
}

class TestClass {
  final TestMethod testMethod;

  TestClass({required this.testMethod});

  Future<int> getInteger(String key) async {
    return testMethod.getInt(key);
  }
}

class TestMethodMock extends Mock implements TestMethod {
  @override
  Future<int> getInt(String key) {
    return super.noSuchMethod(Invocation.method(#getInt, [key]),
        returnValue: Future<int>.value(1),
        returnValueForMissingStub: Future<int>.value(1));
  }
}

void main() {
  group('TestClass', () {
    late TestClass testClass;
    late TestMethod testMethod;

    setUp(() {
      testMethod = TestMethodMock();
      testClass = TestClass(testMethod: testMethod);
    });

    test('should return the integer value from the method', () async {
      // Arrange
      const key = '1';
      when(testMethod.getInt(key)).thenAnswer((_) => Future<int>.value(1));
      // Act
      final result = await testClass.getInteger(key);

      // Assert
      verify(testMethod.getInt(key));
    });
  });
}
