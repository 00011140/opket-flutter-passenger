import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SmsApiClient {
  static final SmsApiClient _instance = SmsApiClient._internal();
  factory SmsApiClient() => _instance;

  late Dio dio;

  SmsApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://notify.eskiz.uz/api/',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
          compact: true,
          maxWidth: 150,
        ),
      );
    }

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Skip token logic for login and refresh requests
          if (options.path.contains('auth/login') ||
              options.path.contains('auth/refresh')) {
            return handler.next(options);
          }

          final prefs = await SharedPreferences.getInstance();
          String? token = prefs.getString('sms_token');

          if (token == null) {
            final newToken = await _loginEskiz(); // login and get token
            if (newToken != null) {
              token = newToken;
              options.headers['Authorization'] = 'Bearer $token';
            }
          } else {
            options.headers['Authorization'] = 'Bearer $token';
          }

          handler.next(options);
        },
        onError: (DioException e, handler) async {
          // Auto refresh token when 401
          if (e.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final request = e.requestOptions;
              return handler.resolve(await dio.fetch(request));
            }
          }
          return handler.next(e);
        },
      ),
    );
  }

  Future<bool> _refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('sms_token');

      final response = await dio.patch(
        'auth/refresh',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      final newToken = response.data['data']['token'];

      await prefs.setString('sms_token', newToken);

      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> _loginEskiz() async {
    try {
      final response = await dio.post(
        'auth/login',
        data: FormData.fromMap({
          'email': "opketme@gmail.com",
          'password': "CCuZYJXp3b05PjiGq1TXdxe9cR0GXkj4btJqMcBJ",
        }),
      );

      final token = response.data['data']['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('sms_token', token);
      return token;
    } on DioException catch (e, st) {
      print("e.response");
      print(e.response);

      rethrow;
    }
  }
}
