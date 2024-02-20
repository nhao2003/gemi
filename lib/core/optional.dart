/// A container object which may or may not contain a non-null value.
/// If a value is present, `isPresent` will return `true` and `value` will return the value.
/// Example:
/// ```dart
/// final optional = Optional(1);
/// print(optional.isPresent); // true
/// print(optional.value); // 1
/// ```
/// Example:
/// ```dart
/// final optional = Optional.empty();
/// print(optional.isPresent); // false
/// print(optional.value); // null
/// ```
class Optional<T> {
  final T? _value;
  final bool _isPresent;

  /// Creates an `Optional` with the given value.
  ///  - If the value is `null`, the `Optional` will be empty.
  /// - If the value is not `null`, the `Optional` will be present.
  ///
  /// Example:
  /// ```dart
  /// final optional = Optional(1);
  /// print(optional.isPresent); // true
  /// print(optional.value); // 1
  /// ```
  const Optional(this._value) : _isPresent = true;

  /// Creates an empty `Optional`.
  /// The `Optional` will not have a value.
  /// Example:
  /// ```dart
  /// final optional = Optional.empty();
  /// print(optional.isPresent); // false
  /// print(optional.value); // null
  /// ```

  const Optional.empty()
      : _value = null,
        _isPresent = false;

  /// Returns `true` if the `Optional` is present.
  /// Example:
  /// ```dart
  /// final optional = Optional(1);
  /// print(optional.isPresent); // true
  /// ```
  /// Example:
  /// ```dart
  /// final optional = Optional.empty();
  /// print(optional.isPresent); // false
  ///
  bool get isPresent => _isPresent;

  /// Returns the value of the `Optional`.
  T? get value => _value;

  /// If a value is present, apply the provided mapping function to it, and if the result is non-null, return an `Optional` describing the result.
  /// Otherwise return an empty `Optional`.
  /// Example:
  /// ```dart
  /// final optional = Optional(1);
  /// final result = optional.map((value) => value + 1);
  /// print(result.isPresent); // true
  /// print(result.value); // 2
  /// ```
  /// Example:
  /// ```dart
  /// final optional = Optional.empty();
  /// final result = optional.map((value) => value + 1);
  /// print(result.isPresent); // false
  /// print(result.value); // null
  T getOrElse(T other) => isPresent ? value as T : other;

  /// If a value is present, apply the provided mapping function to it, and if the result is non-null, return an `Optional` describing the result.
  /// Otherwise return an empty `Optional`.
  /// Example:
  /// ```dart
  /// final optional = Optional(1);
  /// final result = optional.map((value) => value + 1);
  /// print(result.isPresent); // true
  /// print(result.value); // 2
  /// ```
  /// Example:
  /// ```dart
  /// final optional = Optional.empty();
  /// final result = optional.map((value) => value + 1);
  /// print(result.isPresent); // false
  /// print(result.value); // null
  /// ```
  Optional<R> map<R>(R Function(T value) mapper) =>
      isPresent ? Optional(mapper(value as T)) : Optional<R>.empty();
}
