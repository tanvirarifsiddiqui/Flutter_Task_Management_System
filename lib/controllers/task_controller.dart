import 'dart:convert';

import 'package:crud_practice_with_laravel/models/task.dart';
import 'package:crud_practice_with_laravel/services/task_services.dart';
import 'package:crud_practice_with_laravel/utils/global_functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController {
  bool isLoading = false;
  final String token;
  late TaskServices taskServices;
  List<TaskModel> allTasks = [];
  TaskController(this.token);

  @override
  void onInit() {
    super.onInit();
    taskServices = TaskServices(token);
    getAllTasks();
  }

  void _setLoading(bool value) {
    isLoading = value;
    update();
  }

  void clearTasks() {
    allTasks.clear();
  }

  Future<void> getAllTasks() async {
    _setLoading(true);
    try {
      http.Response response = await taskServices.getTasks();
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        // allTasks.addAll(TaskModel.fromJson(data))
        print(data);
        // allTasks = data.map((task)=> TaskModel.fromJson(task)).toList();
        data.forEach((element) {
          allTasks.add(TaskModel.fromJson(element));
        });
      }
    } catch (e) {
      errorSnackMessage(e);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTask(
    int userId,
    String title,
    String description,
    String status,
    String date,
    int priority,
  ) async {
    http.Response response = await taskServices.addTask(
      userId,
      title,
      description,
      status,
      date,
      priority,
    );
    try {
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        allTasks.add(TaskModel.fromJson(data));
        update();
      }
    } catch (e) {
      errorSnackMessage(e);
    }
  }

  Future<void> updateTask(
    int index,
    int taskId,
    String title,
    String description,
    String status,
    String date,
    int priority,
  ) async {
    http.Response response = await taskServices.updateTask(
      taskId,
      title,
      description,
      status,
      date,
      priority,
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      allTasks[index] = TaskModel.fromJson(data);
      update();
    }
  }

  Future<void> deleteTask(int taskId, int index) async {
    http.Response response = await taskServices.deleteTask(taskId);
    if (response.statusCode == 204) {
      allTasks.removeAt(index);
      update();
    }
  }
}
