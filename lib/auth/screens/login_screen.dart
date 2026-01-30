import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/gradient_button.dart';
import 'package:nexuscrm/widgets/modern_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundLight,
          image: DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=2564&auto=format&fit=crop"), // Abstract subtle background
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Stack(
          children: [
            // Decorative background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primaryColor.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.secondaryColor.withOpacity(0.1),
                ),
              ),
            ),
            
            // Main Content
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon/Logo
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 20,
                            spreadRadius: 5,
                          )
                        ]
                      ),
                      child: const Icon(
                        Icons.rocket_launch_rounded, // More futuristic icon
                        size: 48,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    GlassCard(
                      child: Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              "Welcome Back",
                              textAlign: TextAlign.center,
                              style: AppTheme.heading2,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Sign in to access your dashboard",
                              textAlign: TextAlign.center,
                              style: AppTheme.bodyText,
                            ),
                            const SizedBox(height: 32),
                            
                            ModernTextField(
                              controller: controller.emailController,
                              hintText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            
                            ModernTextField(
                              controller: controller.passwordController,
                              hintText: "Password",
                              prefixIcon: Icons.lock_outline,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your password";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 32),
                            
                            Obx(() => GradientButton(
                              text: "Sign In",
                              isLoading: controller.isLoading.value,
                              onPressed: () {
                                if (controller.formKey.currentState!.validate()) {
                                  controller.login();
                                }
                              },
                            )),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Text(
                      "Powered by NexusCRM",
                      style: AppTheme.bodyText.copyWith(
                        fontSize: 12, 
                        color: AppTheme.textSecondary.withOpacity(0.7)
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
