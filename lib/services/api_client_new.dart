import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:opket/core/env.dart';
import 'package:opket/services/auth_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClientNew {
  final Dio _dio;
  final Dio _refreshDio; // Separate Dio instance for refresh
  final AuthStorage tokenStorage;

  static const Duration timeout = Duration(seconds: 20);

  bool _isRefreshing = false;
  Completer<bool>? _refreshCompleter;

  ApiClientNew({required this.tokenStorage, String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? Env.baseUrl,
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: timeout,
          contentType: 'application/json',
        ),
      ),
      _refreshDio = Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
          connectTimeout: timeout,
          receiveTimeout: timeout,
          sendTimeout: timeout,
          contentType: 'application/json',
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(onRequest: _onRequest, onError: _onError),
    );

    if (kDebugMode) {
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          error: true,
        ),
      );
    }
  }

  // =====================================================
  // REQUEST INTERCEPTOR
  // =====================================================
  Future<void> _onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await tokenStorage.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  // =====================================================
  // ERROR INTERCEPTOR
  // =====================================================
  Future<void> _onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final statusCode = err.response?.statusCode;

    // Prevent infinite retry loop
    final alreadyRetried = err.requestOptions.extra['alreadyRetried'] == true;

    if (statusCode == 401 && !alreadyRetried) {
      final refreshed = await _refreshToken();

      if (refreshed) {
        final response = await _retryRequest(err.requestOptions);
        return handler.resolve(response);
      }
    }

    handler.next(err);
  }

  // =====================================================
  // REFRESH TOKEN
  // =====================================================
  Future<bool> _refreshToken() async {
    if (_isRefreshing) {
      return _refreshCompleter!.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer();

    try {
      final refreshToken = await tokenStorage.getRefreshToken();
      if (refreshToken == null) {
        _refreshCompleter!.complete(false);
        return false;
      }

      final response = await _refreshDio.post(
        "/driver/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final newAccess = response.data["accessToken"];
      final newRefresh = response.data["refreshToken"];

      if (newAccess == null || newRefresh == null) {
        throw Exception("Invalid refresh response");
      }

      await tokenStorage.setAccessToken(newAccess);
      await tokenStorage.setRefreshToken(newRefresh);

      _refreshCompleter!.complete(true);
      return true;
    } catch (_) {
      await tokenStorage.clear();
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // =====================================================
  // RETRY ORIGINAL REQUEST
  // =====================================================
  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final accessToken = await tokenStorage.getAccessToken();

    final newOptions = requestOptions.copyWith(
      headers: {
        ...requestOptions.headers,
        "Authorization": "Bearer $accessToken",
      },
      extra: {...requestOptions.extra, "alreadyRetried": true},
    );

    return _dio.fetch(newOptions);
  }

  // =====================================================
  // PUBLIC METHODS
  // =====================================================
  Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data, Options? options}) {
    return _dio.post(path, data: data, options: options);
  }

  Future<Response> put(String path, dynamic data) {
    return _dio.put(path, data: data);
  }

  Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }
}
