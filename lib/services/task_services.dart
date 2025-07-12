import 'dart:convert';

import 'package:crud_practice_with_laravel/services/api_constant.dart';
import 'package:http/http.dart' as http;

class TaskServices {
  String token;
  TaskServices(this.token);

  Future<http.Response> getTasks() async {
    http.Response response = await http.get(
      Uri.parse(ApiConstants.tasks),
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
    );
    return response;
  }

  Future<http.Response> addTask(
    int userId,
    String title,
    String description,
    String status,
    String date,
    int priority,
  ) async {
    http.Response response = await http.post(
      Uri.parse(ApiConstants.tasks),
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "user_id": userId,
        "title": title,
        "description": description,
        "status": status,
        "due_date": date,
        "priority": priority,
      }),
    );
    return response;
  }

  Future<http.Response> updateTask(
      int taskId,
      String title,
      String description,
      String status,
      String date,
      int priority,
      ) async {
    http.Response response = await http.put(
      Uri.parse("${ApiConstants.tasks}/$taskId"),
      headers: {
        "Content-type": "Application/json",
        "Authorization": "Bearer $token",
      },
      body: jsonEncode({
        "title": title,
        "description": description,
        "status": status,
        "due_date": date,
        "priority": priority,
      }),
    );
    return response;
  }

  Future<http.Response>deleteTask(int id)async{
    http.Response response = await http.delete(Uri.parse("${ApiConstants.tasks}/$id"),
    headers: {
      "Content-type": "Application/json",
      "Authorization": "Bearer $token",
    });
    return response;
  }
}
