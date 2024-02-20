abstract class DataSourceException implements Exception {
  String? _message;

  DataSourceException({
    required String? message,
  }) : _message = message;

  String get message => _message!;

  @override
  String toString() {
    return 'CustomException: $message';
  }
}

class RemoteDataSourceException extends DataSourceException {
  final String? statusCode;

  RemoteDataSourceException({
    required String message,
    this.statusCode,
  }) : super(message: message);

  @override
  String toString() {
    return 'RemoteDataSourceException: $message, statusCode: $statusCode';
  }
}

class LocalDataSourceException extends DataSourceException {
  LocalDataSourceException({
    required String message,
  }) : super(message: message);

  @override
  String toString() {
    return 'LocalDataSourceException: $message';
  }
}
