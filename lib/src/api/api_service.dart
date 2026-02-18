import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_config.dart';

class ApiService {
  static final Dio _dio = Dio();
  static final _storage = const FlutterSecureStorage();

  static Dio get dio => _dio;
  static FlutterSecureStorage get storage => _storage;

  static void init() {
    _dio.options.baseUrl = ApiConfig.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            final refreshToken = await _storage.read(key: 'refresh_token');
            if (refreshToken != null) {
              try {
                // Create a new Dio instance to avoid infinite loops with interceptors
                final tokenDio = Dio();
                tokenDio.options.baseUrl = ApiConfig.baseUrl;

                final response = await tokenDio.post(
                  '/users/renew-token',
                  data: {'refresh_token': refreshToken},
                );

                if (response.statusCode == 200) {
                  final newAccessToken = response.data['data']['access_token'];
                  await _storage.write(
                    key: 'access_token',
                    value: newAccessToken,
                  );

                  // Retry original request with new token
                  final opts = e.requestOptions;
                  opts.headers['Authorization'] = 'Bearer $newAccessToken';

                  final clonedRequest = await _dio.request(
                    opts.path,
                    options: Options(
                      method: opts.method,
                      headers: opts.headers,
                      contentType: opts.contentType,
                      responseType: opts.responseType,
                      followRedirects: opts.followRedirects,
                      validateStatus: opts.validateStatus,
                      receiveTimeout: opts.receiveTimeout,
                      sendTimeout: opts.sendTimeout,
                      extra: opts.extra,
                    ),
                    data: opts.data,
                    queryParameters: opts.queryParameters,
                  );

                  return handler.resolve(clonedRequest);
                }
              } catch (refreshError) {
                // Token refresh failed, user might need to login again
                await _storage.delete(key: 'access_token');
                await _storage.delete(key: 'refresh_token');
                return handler.next(e); // Propagate original 401
              }
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  static Future<String?> getBranchId() async {
    return await _storage.read(key: 'branch_id');
  }

  static Future<String?> getUserId() async {
    return await _storage.read(key: 'user_id');
  }

  static Future<String?> getUserRole() async {
    return await _storage.read(key: 'role');
  }
}
