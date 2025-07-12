import 'package:crud_practice_with_laravel/routes/route_helper.php.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  // final AuthController auth = Get.find();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: GetBuilder<AuthController>(
        builder: (auth) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                ),
                SizedBox(height: 20),
                auth.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton(onPressed: () {
                      auth.login(emailController.text.trim(), passwordController.text);
                }, child: Text("Login")),
                SizedBox(height: 20,),
                TextButton(onPressed: (){
                  Get.toNamed(RouteHelper.registration);
                }, child: Text("Create an Account"))
              ],
            ),
          );
        },
      ),
    );
  }
}
