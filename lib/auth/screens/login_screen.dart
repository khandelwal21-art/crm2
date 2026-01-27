import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/widgets/screen_widgets/my_text_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  /// 🔷 App Logo / Title
                  Column(
                    children: const [
                      Icon(
                        Icons.account_circle,
                        size: 90,
                        color: Color(0xFF004D40),
                      ),
                      SizedBox(height: 12),
                      Text(
                        "Welcome Back",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        "Login to continue",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  /// 📧 Username
                  MyTextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                      hintText: "Username or Email",
                      prefixIcon:Icons.person_outline,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter your username";}
                        else{return null;}
                      }

                    ),

                  const SizedBox(height: 20),
                  /// 🔐 Password
                  MyTextField(
                    controller: controller.passwordController,
                    obscureText: true,
                      hintText: "Password",
                      prefixIcon:Icons.lock_outline,
                      validator: (value){
                      if(value!.isEmpty){
                        return "Please enter your password";
                      }else{
                        return null;
                      }}
                    ),


                  const SizedBox(height: 30),

                  /// 🔘 Login Button
                  SizedBox(
                    height: 52,
                    child: Obx( () => ElevatedButton(
                        onPressed: controller.isLoading.value ? null :
                        (){
                          if (controller.formKey.currentState!.validate()) {
                            controller.login();   // call login only when valid
                          }                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004D40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        child:controller.isLoading.value
                            ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// ℹ️ Footer
                  const Text(
                    "Secure login powered by NexusCRM",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
