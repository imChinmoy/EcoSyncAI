import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Network {
  static final Dio dio = Dio();
  static late SharedPreferences prefs;
  static String token = prefs.getString('token') ?? '';
  
  static Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  static Future<Response> get(String url) async {
    return await dio.get(url);
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