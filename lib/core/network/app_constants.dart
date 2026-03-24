class AppConstants {
  static const String baseUrl = 'https://api.ecosyncai.com';
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
  static const String createBin = '/bins';
  static const String getBin = '/bins/{id}';
  static const String updateBin = '/bins/{id}';
  static const String deleteBin = '/bins/{id}';
}