import 'dart:convert';

import 'package:crud_practice_with_laravel/services/api_constant.dart';
import 'package:http/http.dart' as http;

class AuthService {
  Future<http.Response> register(String name, String email, String password, String passwordConfirmation) async {
    http.Response response = await http.post(
      Uri.parse(ApiConstants.register),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode({
        "name" : name,
        "email" : email,
        "password" : password,
        "password_confirmation" : passwordConfirmation
      })
    );
    return response;
  }

  Future<http.Response> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse(ApiConstants.login),
      headers: {"Content-type": "Application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    return response;
  }

  Future<http.Response> getUserInfo(String token) async {
    http.Response response = await http.get(
      Uri.parse(ApiConstants.userInfo),
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token", //very important
      },
    );
    return response;
  }

  Future<http.Response> logOut(String token) async {
    http.Response response = await http.post(
      Uri.parse(ApiConstants.logout),
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }
}
