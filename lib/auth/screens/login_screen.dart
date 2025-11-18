import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final AuthContoller controller=Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
            TextField(
              controller: controller.emailController,
              decoration:InputDecoration(
                hintText: "Username",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0)
                )
              )
            ),
            SizedBox(height: 18,),
            TextField(
              controller: controller.passwordController,
                obscureText: true,
                decoration:InputDecoration(
                    hintText: "Password",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)
                    )
                )
            ),

                ElevatedButton(
                  onPressed: (){
                    controller.login();
                  },child: Text("Login",))
                    ],
                  ),
          )),

    );
  }
}
