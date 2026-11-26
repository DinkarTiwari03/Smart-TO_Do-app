class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(this.message, {this.code, this.details});

  @override
  String toString() => 'AppException(code: $code, message: $message, details: $details)';
}

class NetworkException extends AppException {
  final int? statusCode;

  const NetworkException(
    super.message, {
    super.code,
    super.details,
    this.statusCode,
  });
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, {super.code, super.details});
}

class ValidationException extends AppException {
  const ValidationException(super.message, {super.code, super.details});
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, {super.code, super.details});
}
