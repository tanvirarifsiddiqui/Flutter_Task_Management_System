import 'dart:convert';

import 'package:crud_practice_with_laravel/controllers/task_controller.dart';
import 'package:crud_practice_with_laravel/models/user.dart';
import 'package:crud_practice_with_laravel/routes/route_helper.php.dart';
import 'package:crud_practice_with_laravel/services/auth_services.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/global_functions.dart';
class AuthController extends GetxController{

  late AuthService authService;
  bool isLoading = false;
  UserModel? user;
  String? token;

  //getting shared preference instance from main function
  final SharedPreferences prefs;
  AuthController(this.prefs);

  @override
  void onInit() {
    super.onInit();
    authService = AuthService();
    autoLogin();
  }

  void _setLoading(bool value){
    isLoading = value;
    update();
  }

  void _injectDependency(){
    // ✅ Register TaskController only after token is available
    Get.put(TaskController(token!)); //dependency injection
  }


  void _handleLogin(http.Response response){
    final data = jsonDecode(response.body);
    user = UserModel.fromJson(data["user"]);
    token = data['token'];

    _injectDependency();

    Get.offAllNamed(RouteHelper.home);
    prefs.setString("token", token!);
  }

  Future<void>register(String name, String email, String password, String passwordConfirmation)async{
    _setLoading(true);
    try{
      http.Response response = await authService.register(name, email, password, passwordConfirmation);
      if(response.statusCode == 201){
        _handleLogin(response);
      }
    }catch (e){
      errorSnackMessage(e);
    }finally{
      _setLoading(false);
    }
  }
  
  Future<void> login(String email, String password) async {
    _setLoading(true);
    try{
      http.Response response = await authService.login(email, password);
      if(response.statusCode == 200){
        _handleLogin(response);
      }
    }catch (e){
      errorSnackMessage(e);
    }finally{
      _setLoading(false);
    }
  }

  Future<void> autoLogin()async{
    final storedToken = prefs.getString("token");
    if(storedToken != null){
      token = storedToken;
      _injectDependency();
    fetchUserInfo();
    }
  }

  Future<void> fetchUserInfo()async {
    _setLoading(true);
    if(token == null) return;
    try{
      http.Response response = await authService.getUserInfo(token!);
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        user = UserModel.fromJson(data);
      }
    }catch(e){
      errorSnackMessage(e);
    }finally{
      _setLoading(false);
    }
  }

  Future<void>logout()async{
    _setLoading(true);
    http.Response response = await authService.logOut(token!);
    try{
      if(response.statusCode == 200){
        await prefs.remove("token");
        user = null;
        token = null;
        Get.offAllNamed(RouteHelper.login);
      }
    }catch(e){
      errorSnackMessage(e);
    }finally{
      _setLoading(false);
    }
  }
}
