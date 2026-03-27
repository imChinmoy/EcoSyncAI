import 'package:dio/dio.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'dart:developer';

class DioConfig {
  static final Dio dio = Dio();
  static bool _loggingInitialized = false;

  static Future<void> init() async {
    dio.options.baseUrl = AppConstants.baseUrl;
    _initLoggingInterceptor();
  }

  static Future<void> setToken(String token) async {
    dio.options.headers['Authorization'] = 'Bearer $token';
  }
  static Future<void> content(String contentType) async {
    dio.options.headers['Content-Type'] = contentType;
  }

  static Future<void> removeToken() async {
    dio.options.headers.remove('Authorization');
  }

  static Future<void> clearToken() async {
    dio.options.headers.remove('Authorization');
  }

  static void _initLoggingInterceptor() {
    if (_loggingInitialized) return;
    _loggingInitialized = true;

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          log(
            '[API REQUEST] ${options.method} ${options.baseUrl}${options.path} '
            'query=${options.queryParameters} body=${_safeData(options.data)}',
            name: 'DioConfig',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          final request = response.requestOptions;
          log(
            '[API RESPONSE] ${request.method} ${request.baseUrl}${request.path} '
            'status=${response.statusCode} data=${_safeData(response.data)}',
            name: 'DioConfig',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          final request = error.requestOptions;
          log(
            '[API ERROR] ${request.method} ${request.baseUrl}${request.path} '
            'status=${error.response?.statusCode} message=${error.message} '
            'data=${_safeData(error.response?.data)}',
            name: 'DioConfig',
          );
          handler.next(error);
        },
      ),
    );
  }

  static String _safeData(dynamic data) {
    final text = data?.toString() ?? 'null';
    if (text.length <= 1500) return text;
    return '${text.substring(0, 1500)}...<truncated>';
  }
}