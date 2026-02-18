import 'package:dio/dio.dart';
import 'dart:io';
import 'api_service.dart';

class ApiAuth {
  static Future<Map<String, dynamic>> login(
    String userId,
    String password,
  ) async {
    try {
      final response = await ApiService.dio.post(
        '/users/login',
        data: {'user_id': userId, 'password': password},
      );

      if (response.statusCode == 200) {
        print("Login Success Response: ${response.data}");
        final data = response.data['data'];
        await ApiService.storage.write(
          key: 'access_token',
          value: data['access_token'],
        );
        if (data['user'] != null) {
          await ApiService.storage.write(
            key: 'branch_id',
            value: data['user']['branch_id'] ?? '',
          );
          await ApiService.storage.write(
            key: 'user_id',
            value: data['user']['id'] ?? '',
          );
          await ApiService.storage.write(
            key: 'role',
            value: data['user']['role']?.toString() ?? '',
          );
        } else {
          if (data['branch_id'] != null) {
            await ApiService.storage.write(
              key: 'branch_id',
              value: data['branch_id'],
            );
          }
          if (data['id'] != null) {
            await ApiService.storage.write(key: 'user_id', value: data['id']);
          }
          if (data['role'] != null) {
            await ApiService.storage.write(
              key: 'role',
              value: data['role'].toString(),
            );
          }
        }

        await ApiService.storage.write(
          key: 'refresh_token',
          value: data['refresh_token'],
        );
        return {'success': true, 'data': data};
      } else {
        return {'success': false, 'message': 'Login failed'};
      }
    } on DioException catch (e) {
      print("Login Error Response: ${e.response?.data}");

      String message = 'Something went wrong. Please try again.';

      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout ||
          e.error is SocketException) {
        message = 'Please check your internet connection.';
      } else if (e.response?.statusCode == 400 ||
          e.response?.statusCode == 401) {
        message = 'Invalid email or password.';
      } else if (e.response?.data['message'] != null) {
        message = e.response?.data['message'];
      }

      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<void> logout() async {
    await ApiService.storage.delete(key: 'access_token');
    await ApiService.storage.delete(key: 'refresh_token');
  }
}
