import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  static final String baseUrl = dotenv.env['API_BASE_URL'] ?? '';
}

class ApiEndpoints {

  //auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';
  static const String verifyPhone = '/auth/verify-phone';
  static const String verifyCode = '/auth/verify-code';

  //bins
  static const String getBins = '/bins';
  static const String getWards = '/wards';
  static const String createBin = '/bins';
  static const String getBin = '/bins/{id}';
  static const String updateBin = '/bins/{id}';
  static const String deleteBin = '/bins/{id}';

  //scanner
  static const String classifyWaste = '/classify';

  //report
  static const String complaint = '/complaint';
}