import 'package:dio/dio.dart';
import 'package:ecosyncai/core/network/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:developer';

class Network {
  static final Dio dio = Dio();
  static late SharedPreferences prefs;
  static String token = '';
  static bool _loggingInitialized = false;

  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';

    dio.options = dio.options.copyWith(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      sendTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );

    _initLoggingInterceptor();
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
            name: 'Network',
          );
          handler.next(options);
        },
        onResponse: (response, handler) {
          final request = response.requestOptions;
          log(
            '[API RESPONSE] ${request.method} ${request.baseUrl}${request.path} '
            'status=${response.statusCode} data=${_safeData(response.data)}',
            name: 'Network',
          );
          handler.next(response);
        },
        onError: (error, handler) {
          final request = error.requestOptions;
          log(
            '[API ERROR] ${request.method} ${request.baseUrl}${request.path} '
            'status=${error.response?.statusCode} message=${error.message} '
            'data=${_safeData(error.response?.data)}',
            name: 'Network',
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

  static Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return await dio.get(url, queryParameters: queryParameters);
  }

  static Future<Response> post(String url, dynamic data) async {
    return await dio.post(url, data: data);
  }

  static Future<Response> put(String url, dynamic data) async {
    return await dio.put(url, data: data);
  }

  static Future<Response> delete(String url) async {
    return await dio.delete(url);
  }

  static Future<Response> patch(String url, dynamic data) async {
    return await dio.patch(url, data: data);
  }

}