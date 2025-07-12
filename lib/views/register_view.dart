import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: GetBuilder<AuthController>(
        builder: (auth) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: passwordCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: confirmCtrl,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Confirm Password",
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (passwordCtrl.text == confirmCtrl.text) {
                      auth.register(
                        nameCtrl.text.trim(),
                        emailCtrl.text.trim(),
                        passwordCtrl.text,
                        confirmCtrl.text,
                      );
                    } else {
                      Get.snackbar(
                        "Invalid Confirm Password",
                        "Please Confirm your Password",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  },
                  child: Text("Register"),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: Text("Already Have an Account?"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
