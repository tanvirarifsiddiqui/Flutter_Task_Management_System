import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../routes/route_helper.php.dart';
import '../utils/app_colors.dart';  // Ensure this path matches your project

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Apply a soft gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent, AppColors.primary],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.surface,
              shadowColor: AppColors.shadow,
              child: Padding(
                padding: EdgeInsets.all(24),
                child: GetBuilder<AuthController>(
                  builder: (auth) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Logo or title
                        FlutterLogo(size: 72),
                        SizedBox(height: 24),

                        // Email field
                        TextField(
                          controller: emailController,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon: Icon(Icons.email, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Password field
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon: Icon(Icons.lock, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: auth.isLoading
                              ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                              : ElevatedButton(
                            onPressed: () {
                              auth.login(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: EdgeInsets.zero,
                              elevation: 4,
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.primary, AppColors.primaryDark],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),

                        // Registration link
                        TextButton(
                          onPressed: () => Get.toNamed(RouteHelper.registration),
                          child: Text(
                            'Create an Account',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}