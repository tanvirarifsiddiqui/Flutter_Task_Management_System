import 'dart:convert';

import 'package:crud_practice_with_laravel/models/task.dart';
import 'package:crud_practice_with_laravel/services/task_services.dart';
import 'package:crud_practice_with_laravel/utils/global_functions.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class TaskController extends GetxController{
  bool isLoading = false;
  final String token;
  late TaskServices taskServices;
  List<TaskModel> allTasks = [];
  TaskController(this.token);

  @override
  void onInit() {
    super.onInit();
    taskServices = TaskServices();
    getAllTasks();
  }

  void _setLoading(bool value){
    isLoading = value;
  }

  Future<void>getAllTasks()async{
    _setLoading(true);
    try{
      http.Response response = await taskServices.getTasks(token);
      if(response.statusCode == 200){
        final List<dynamic>data = jsonDecode(response.body);
        // allTasks.addAll(TaskModel.fromJson(data))

        // allTasks = data.map((task)=> TaskModel.fromJson(task)).toList();
        data.forEach((element){
          allTasks.add(TaskModel.fromJson(element));
        });
      }
    }catch (e){
      errorSnackMessage(e);
    }finally{
      _setLoading(false);
    }
  }

}