import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../services/api_constant.dart';

class BackupController extends GetxController {
  // Reactive state
  final Rxn<UserModel> user    = Rxn<UserModel>();
  final RxBool        isLoading = false.obs;

  SharedPreferences? _prefs;

  @override
  void onInit() {
    super.onInit();
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    final token = _prefs?.getString('token');
    if (token != null) {
      await fetchUser();
    }
  }

  // Register & store token
  Future<void> register(String name, String email, String password, String passwordConfirmation) async {
    isLoading.value = true;
    final url = Uri.parse(ApiConstants.register);
    final body = jsonEncode({
      'name':                  name,
      'email':                 email,
      'password':              password,
      'password_confirmation': passwordConfirmation,
    });

    final res = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (res.statusCode == 201) {
      final data  = jsonDecode(res.body);
      final token = data['token'];
      await _prefs?.setString('token', token);
      await fetchUser();
    } else {
      final err = jsonDecode(res.body)['message'] ?? 'Registration failed';
      Get.snackbar('Error', err, snackPosition: SnackPosition.BOTTOM);
    }
    isLoading.value = false;
  }

  // Login & store token
  Future<void> login(String email, String password) async {
    isLoading.value = true;
    final url = Uri.parse(ApiConstants.login);
    final res = await http.post(url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (res.statusCode == 200) {
      final data  = jsonDecode(res.body);
      final token = data['token'];
      await _prefs?.setString('token', token);
      await fetchUser();
    } else {
      final err = jsonDecode(res.body)['message'] ?? 'Login failed';
      Get.snackbar('Error', err, snackPosition: SnackPosition.BOTTOM);
    }
    isLoading.value = false;
  }

  // Fetch authenticated user
  Future<void> fetchUser() async {
    isLoading.value = true;
    final token = _prefs?.getString('token');
    if (token == null) {
      user.value     = null;
      isLoading.value = false;
      return;
    }

    final url = Uri.parse('${ApiConstants.baseUrl}/user');
    final res = await http.get(url, headers: {
      'Content-Type':  'application/json',
      'Accept':        'application/json',
      'Authorization': 'Bearer $token',
    });

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      user.value    = UserModel.fromJson(data);
    } else {
      await logout();
    }
    isLoading.value = false;
  }

  // Logout & clear token
  Future<void> logout() async {
    isLoading.value = true;
    await _prefs?.remove('token');
    user.value     = null;
    isLoading.value = false;
  }
}

