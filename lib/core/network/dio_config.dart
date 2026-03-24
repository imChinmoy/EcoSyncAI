import 'package:dio/dio.dart';
import 'package:ecosyncai/core/network/app_constants.dart';

class DioConfig {
  static final Dio dio = Dio();

  static Future<void> init() async {
    dio.options.baseUrl = AppConstants.baseUrl;
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
}