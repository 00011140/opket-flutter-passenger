import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:opket/core/env.dart';
import 'package:opket/core/services/auth_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late final Dio _dio;
  // final String? baseUrl;
  final TokenStorage tokenStorage;

  static const Duration timeout = Duration(seconds: 20);

  ApiClient({required this.tokenStorage, String? baseUrl}) {
    print("♻️♻️♻️♻️♻️♻️♻️");
    print(baseUrl);

    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl ?? Env.baseUrl,
        connectTimeout: timeout,
        receiveTimeout: timeout,
        sendTimeout: timeout,
        contentType: 'application/json',
      ),
    );

    // -----------------------------------------------------
    // Interceptors
    // -----------------------------------------------------
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: _onRequestInterceptor,
        onError: _onErrorInterceptor,
      ),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
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
  }

  // -----------------------------------------------------
  // REQUEST INTERCEPTOR → Inject JWT Token
  // -----------------------------------------------------
  Future<void> _onRequestInterceptor(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  // -----------------------------------------------------
  // ERROR INTERCEPTOR → Refresh Token Retry Handler
  // -----------------------------------------------------
  Future<void> _onErrorInterceptor(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // If unauthorized → try refresh token
    // if (err.response?.statusCode == 401) {
    //   final refreshed = await _refreshToken();

    //   print("🌀 IS REFRESHED: $refreshed");
    //   if (refreshed) {
    //     // Retry original request with new token
    //     final retryRequest = await _retryRequest(err.requestOptions);
    //     return handler.resolve(retryRequest);
    //   }
    // }

    handler.next(err);
  }

  // -----------------------------------------------------
  // REFRESH TOKEN LOGIC
  // -----------------------------------------------------
  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  // Future<bool> _refreshToken() async {
  //   if (_isRefreshing) {
  //     return await _refreshCompleter!.future;
  //   }

  //   _isRefreshing = true;
  //   _refreshCompleter = Completer();

  //   try {
  //     final refreshToken = await tokenStorage.getRefreshToken();
  //     if (refreshToken == null) {
  //       _refreshCompleter!.complete(false);
  //       _isRefreshing = false;
  //       return false;
  //     }

  //     // 🔥 Call backend refresh endpoint
  //     final response = await _dio.post(
  //       "/driver/refresh-token",
  //       data: {"refreshToken": refreshToken},
  //     );

  //     print("🌀 IS REFRESHED: ${response.data}");

  //     final newAccess = response.data["accessToken"];
  //     final newRefresh = response.data["refreshToken"];

  //     await tokenStorage.setAccessToken(newAccess);
  //     await tokenStorage.setRefreshToken(newRefresh);

  //     _refreshCompleter!.complete(true);
  //     return true;
  //   } catch (e, stackTrace) {
  //     await tokenStorage.clear();

  //     // This will also be picked up by PrettyDioLogger if it's a DioException
  //     if (e is DioException) {
  //       print("🚨 DioException during token refresh: ${e.message}");
  //       print("Status: ${e.response?.statusCode}");
  //       print("Data: ${e.response?.data}");
  //     } else {
  //       print("🚨 Exception during token refresh: $e");
  //     }
  //     print("Stack trace: $stackTrace");

  //     _refreshCompleter!.complete(false);
  //     return false;
  //   } finally {
  //     _isRefreshing = false;
  //   }
  // }

  // -----------------------------------------------------
  // RETRY FAILED REQUEST
  // -----------------------------------------------------
  // Future<Response> _retryRequest(RequestOptions requestOptions) async {
  //   final newAccessToken = await tokenStorage.getAccessToken();

  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {
  //       ...requestOptions.headers,
  //       "Authorization": "Bearer $newAccessToken",
  //     },
  //   );

  //   return _dio.request(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }

  // -----------------------------------------------------
  // PUBLIC METHODS
  // -----------------------------------------------------
  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, dynamic data, {Options? options}) {
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, dynamic data) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }
}
