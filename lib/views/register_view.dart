import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../utils/app_colors.dart'; // Ensure this path matches your project

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
      // Full‐screen gradient
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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: AppColors.surface,
              shadowColor: AppColors.shadow,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: GetBuilder<AuthController>(
                  builder: (auth) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title or logo
                        Text(
                          'Create Account',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Name field
                        TextField(
                          controller: nameCtrl,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle:
                            TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.person, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email field
                        TextField(
                          controller: emailCtrl,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle:
                            TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.email, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextField(
                          controller: passwordCtrl,
                          obscureText: true,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle:
                            TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.lock, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Confirm password field
                        TextField(
                          controller: confirmCtrl,
                          obscureText: true,
                          style: TextStyle(color: AppColors.textPrimary),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle:
                            TextStyle(color: AppColors.textSecondary),
                            prefixIcon:
                            Icon(Icons.lock_open, color: AppColors.primary),
                            filled: true,
                            fillColor: AppColors.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Register button
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: auth.isLoading
                              ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                              : ElevatedButton(
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
                                  'Invalid Confirm Password',
                                  'Please confirm your password correctly.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              }
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
                                  colors: [
                                    AppColors.primary,
                                    AppColors.primaryDark
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  'Register',
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
                        const SizedBox(height: 16),

                        // Already have an account
                        TextButton(
                          onPressed: () => Get.back(),
                          child: Text(
                            'Already have an account?',
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