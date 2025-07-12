import 'package:crud_practice_with_laravel/services/api_constant.dart';
import 'package:http/http.dart' as http;


class TaskServices {

  Future<http.Response>getTasks(String token)async{
    http.Response response = await http.get(Uri.parse(ApiConstants.tasks),
    headers: {
      "Content-type" : "Application/json",
      "Authorization" : "Bearer $token"
    });
        return response;
  }

}