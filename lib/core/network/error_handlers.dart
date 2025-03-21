import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'exceptions/api_exception.dart';
import 'exceptions/app_exception.dart';
import 'exceptions/network_exception.dart';
import 'exceptions/not_found_exception.dart';
import 'exceptions/service_unavailable_exception.dart';

abstract class ErrorHandler {
  Exception handleError(dynamic error);
  Exception handleDioError(DioException dioError);
}

class AppErrorHandler implements ErrorHandler {
  final ExceptionMessageFormatter _formatter;

  AppErrorHandler(this._formatter);

  @override
  Exception handleError(dynamic error) {
    if (error is Exception) return error;
    return AppException(message: error.toString());
  }

  @override
  Exception handleDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        return AppException(message: "Request to API server was cancelled");
      case DioExceptionType.connectionTimeout:
        return AppException(message: "Connection timeout with API server");
      case DioExceptionType.connectionError:
        return NetworkException("There is no internet connection");
      case DioExceptionType.receiveTimeout:
        return TimeoutException("Receive timeout in connection with API server");
      case DioExceptionType.sendTimeout:
        return TimeoutException("Send timeout in connection with API server");
      case DioExceptionType.badResponse:
        return _formatter.parseDioErrorResponse(dioError);
      case DioExceptionType.badCertificate:
        return AppException(message: "Bad certificate from API server");
      default:
        return AppException(message: "Unknown error occurred");
    }
  }
}

abstract class ExceptionMessageFormatter {
  Exception parseDioErrorResponse(DioException dioError);
}

class DioExceptionFormatter implements ExceptionMessageFormatter {
  @override
  Exception parseDioErrorResponse(DioException dioError) {
    final response = dioError.response;
    final statusCode = response?.statusCode ?? -1;
    final data = response?.data is Map ? response?.data as Map<String, dynamic> : null;

    try {
      final parsedStatusCode = _getStatusCode(statusCode, data);
      final status = data?['status']?.toString() ?? '';
      final serverMessage = data?['message']?.toString() ?? 'Something went wrong. Please try again later.';

      return _mapStatusCodeToException(
        parsedStatusCode,
        status,
        serverMessage,
      );
    } catch (e, s) {
      return ApiException(
        httpCode: statusCode,
        status: 'parsing_failed',
        message: 'Error parsing server response: $e',
      );
    }
  }

  int _getStatusCode(int statusCode, Map<String, dynamic>? data) {
    if (statusCode == -1 || statusCode == HttpStatus.ok) {
      return data?['statusCode'] as int? ?? statusCode;
    }
    return statusCode;
  }

  Exception _mapStatusCodeToException(int statusCode, String status, String message) {
    switch (statusCode) {
      case HttpStatus.serviceUnavailable:
        return ServiceUnavailableException("Service Temporarily Unavailable");
      case HttpStatus.notFound:
        return NotFoundException(message, status);
      default:
        return ApiException(
          httpCode: statusCode,
          status: status,
          message: message,
        );
    }
  }
}