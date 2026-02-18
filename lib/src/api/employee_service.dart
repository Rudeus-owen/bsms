import 'package:bsms/src/api/api_service.dart';
import 'package:bsms/src/models/employee.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class EmployeeService {
  static Future<Map<String, dynamic>> getEmployees({
    int page = 1,
    int limit = 10,
    int? role,
    String? branchId,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (role != null) 'role': role,
        if (branchId != null) 'branch_id': branchId,
      };

      final response = await ApiService.dio.get(
        '/users/staffs',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['statuscode'] == 200) {
        final List<dynamic> data = response.data['data'];
        final employees = data.map((json) => Employee.fromJson(json)).toList();

        return {
          'success': true,
          'data': employees,
          'total': response.data['total'],
          'totalPages': response.data['totalPages'],
          'page': response.data['page'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to fetch employees',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Get Single Employee Details
  static Future<Map<String, dynamic>> getEmployeeDetails(String id) async {
    try {
      final response = await ApiService.dio.get('/users/staffs/$id');

      if (response.statusCode == 200 && response.data['statuscode'] == 200) {
        return {
          'success': true,
          'data': Employee.fromJson(response.data['data']),
        };
      } else {
        return {'success': false, 'message': response.data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Create Employee
  static Future<Map<String, dynamic>> createEmployee(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('Create Employee Request Data: $data');
      final response = await ApiService.dio.post(
        '/users/staffs/create', // Corrected URL
        data: data,
      );
      debugPrint(
        'Create Employee Response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map &&
            (response.data['statuscode'] == 200 ||
                response.data['statuscode'] == 201)) {
          return {'success': true, 'message': 'Employee created successfully'};
        } else {
          final msg = response.data is Map
              ? response.data['message']
              : 'Unexpected response format';
          return {'success': false, 'message': msg ?? 'Failed to create'};
        }
      } else {
        final msg = response.data is Map
            ? response.data['message']
            : 'Server error ${response.statusCode}';
        return {'success': false, 'message': msg ?? 'Failed to create'};
      }
    } on DioException catch (e) {
      String message = e.message ?? 'Unknown error';
      if (e.response?.data is Map) {
        message = e.response?.data['message'] ?? message;
      } else if (e.response?.data is String) {
        // Handle HTML or plain text error responses
        message = 'Server Error: ${e.response?.statusCode}';
      }
      return {'success': false, 'message': message};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update Employee
  static Future<Map<String, dynamic>> updateEmployee(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('Update Employee Request Data: $data');
      final response = await ApiService.dio.post(
        '/users/staffs/update',
        data: data,
      );
      debugPrint(
        'Update Employee Response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 200) {
          return {'success': true, 'message': 'Employee updated successfully'};
        } else {
          return {
            'success': false,
            'message': response.data['message'] ?? 'Failed to update',
          };
        }
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Delete Employee
  static Future<Map<String, dynamic>> deleteEmployee(String id) async {
    try {
      final response = await ApiService.dio.post(
        '/users/staffs/delete',
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 200) {
          return {'success': true, 'message': 'Employee deleted successfully'};
        } else {
          return {
            'success': false,
            'message': response.data['message'] ?? 'Failed to delete',
          };
        }
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to delete',
        };
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  // Update Password
  static Future<Map<String, dynamic>> updatePassword(
    String userId,
    String newPassword,
  ) async {
    try {
      final response = await ApiService.dio.post(
        '/users/update-password',
        data: {'user_id': userId, 'new_password': newPassword},
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 200) {
          return {'success': true, 'message': 'Password updated successfully'};
        } else {
          return {
            'success': false,
            'message': response.data['message'] ?? 'Failed to update password',
          };
        }
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to update password',
        };
      }
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? e.message,
      };
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
