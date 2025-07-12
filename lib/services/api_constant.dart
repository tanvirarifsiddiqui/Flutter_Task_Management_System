class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Authentication
  static const String register = '$baseUrl/register';
  static const String login    = '$baseUrl/login';
  static const String logout   = '$baseUrl/logout';
  static const String userInfo = '$baseUrl/user'; // get method with token

  // Tasks
  static const String tasks    = '$baseUrl/tasks';
}