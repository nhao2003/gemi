abstract class DataSourceException implements Exception {
  final String? _message;
  dynamic data;
  DataSourceException({
    String? message = 'An error occurred while fetching data',
    this.data,
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
    super.message,
    super.data,
    this.statusCode,
  });

  @override
  String toString() {
    return 'RemoteDataSourceException: $message, statusCode: $statusCode';
  }
}

class LocalDataSourceException extends DataSourceException {
  LocalDataSourceException({
    super.message,
    super.data,
  });

  @override
  String toString() {
    return 'LocalDataSourceException: $message';
  }
}
