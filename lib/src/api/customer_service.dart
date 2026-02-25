import 'package:bsms/src/api/api_service.dart';
import 'package:bsms/src/models/customer.dart';
import 'package:bsms/src/helpers/api_error_handler.dart';
import 'package:flutter/foundation.dart';

class CustomerService {
  static Future<Map<String, dynamic>> getCustomers({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (search != null && search.isNotEmpty) 'search': search,
      };

      final response = await ApiService.dio.get(
        '/customers',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200 && response.data['statuscode'] == 200) {
        final List<dynamic> data = response.data['data'];
        final customers = data.map((json) => Customer.fromJson(json)).toList();

        return {
          'success': true,
          'data': customers,
          'total': response.data['total'],
          'totalPages': response.data['totalPages'],
          'page': response.data['page'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Failed to fetch customers',
        };
      }
    } catch (e) {
      return {'success': false, 'message': ApiErrorHandler.getMessage(e)};
    }
  }

  // Get Single Customer Details
  static Future<Map<String, dynamic>> getCustomerDetails(String id) async {
    try {
      final response = await ApiService.dio.get('/customers/$id');

      if (response.statusCode == 200 && response.data['statuscode'] == 200) {
        return {
          'success': true,
          'data': Customer.fromJson(response.data['data']),
        };
      } else {
        return {'success': false, 'message': response.data['message']};
      }
    } catch (e) {
      return {'success': false, 'message': ApiErrorHandler.getMessage(e)};
    }
  }

  // Create Customer
  static Future<Map<String, dynamic>> createCustomer(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('Create Customer Request Data: $data');
      final response = await ApiService.dio.post(
        '/customers/create',
        data: data,
      );
      debugPrint(
        'Create Customer Response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map &&
            (response.data['statuscode'] == 200 ||
                response.data['statuscode'] == 201)) {
          return {'success': true, 'message': 'Customer created successfully'};
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
    } catch (e) {
      return {'success': false, 'message': ApiErrorHandler.getMessage(e)};
    }
  }

  // Update Customer
  static Future<Map<String, dynamic>> updateCustomer(
    Map<String, dynamic> data,
  ) async {
    try {
      debugPrint('Update Customer Request Data: $data');
      final response = await ApiService.dio.post(
        '/customers/update',
        data: data,
      );
      debugPrint(
        'Update Customer Response: ${response.statusCode} ${response.data}',
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 200) {
          return {'success': true, 'message': 'Customer updated successfully'};
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
    } catch (e) {
      return {'success': false, 'message': ApiErrorHandler.getMessage(e)};
    }
  }

  // Delete Customer
  static Future<Map<String, dynamic>> deleteCustomer(String id) async {
    try {
      final response = await ApiService.dio.post(
        '/customers/delete',
        data: {'id': id},
      );

      if (response.statusCode == 200) {
        if (response.data['statuscode'] == 200) {
          return {'success': true, 'message': 'Customer deleted successfully'};
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
      return {'success': false, 'message': ApiErrorHandler.getMessage(e)};
    }
  }
}
