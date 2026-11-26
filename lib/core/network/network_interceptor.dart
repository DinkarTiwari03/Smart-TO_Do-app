import 'package:dio/dio.dart';
import '../errors/app_exception.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Accept'] = 'application/json';
    options.headers['Content-Type'] = 'application/json';
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final mappedException = _mapDioError(err);
    return handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: mappedException,
        message: mappedException.message,
      ),
    );
  }

  AppException _mapDioError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          'Connection timed out. Please check your network connection.',
          code: 'TIMEOUT',
        );
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        final data = err.response?.data;
        return NetworkException(
          data is Map && data['message'] != null
              ? data['message'].toString()
              : 'Server returned error status code: $statusCode',
          code: 'BAD_RESPONSE',
          statusCode: statusCode,
          details: data,
        );
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.', code: 'CANCELLED');
      case DioExceptionType.connectionError:
        return const NetworkException(
          'Unable to reach server. Please verify network connectivity.',
          code: 'CONNECTION_ERROR',
        );
      default:
        return NetworkException(
          err.message ?? 'An unexpected network error occurred.',
          code: 'UNKNOWN_NETWORK_ERROR',
          details: err.error,
        );
    }
  }
}
