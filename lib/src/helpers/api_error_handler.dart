import 'dart:io';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(Object error) {
    if (error is DioException) {
      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.error is SocketException) {
        return 'Please check your internet connection.';
      }

      if (error.type == DioExceptionType.receiveTimeout) {
        return 'Server took too long to respond. Please try again.';
      }

      if (error.response != null) {
        if (error.response!.data is Map &&
            error.response!.data['message'] != null) {
          return error.response!.data['message'];
        }
        if (error.response!.statusCode == 401) {
          return 'Session expired. Please login again.';
        }
        if (error.response!.statusCode == 500) {
          return 'Server error. Please try again later.';
        }
      }

      return error.message ?? 'Unknown network error';
    }
    return error.toString();
  }
}
