import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';

class HomeView extends StatelessWidget {

  // String token = SharedPreferences.ge
  final auth = Get.find<AuthController>();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [

              IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => auth.logout(),
                ),
        ],
      ),
      body: Center(child: Text('Welcome, ${auth.user?.name ?? 'User'}!')),
    );
  }
}
