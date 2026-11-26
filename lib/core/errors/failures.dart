abstract class Failure {
  final String message;
  final String? code;

  const Failure(this.message, {this.code});

  @override
  String toString() => '$runtimeType: $message (code: $code)';
}

class NetworkFailure extends Failure {
  final int? statusCode;
  const NetworkFailure(super.message, {super.code, this.statusCode});
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, {super.code});
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message, {super.code});
}

class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'An unexpected error occurred.']);
}
