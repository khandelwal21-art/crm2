import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nexuscrm/auth/service/auth_service.dart';
import 'package:nexuscrm/models/user_model.dart';

import '../../services/web_socket_service.dart';

class AuthController extends GetxController{

  final AuthService authService =Get.find();
  final formKey = GlobalKey<FormState>();
  var isLoading=false.obs;
  final storage = GetStorage();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();

  var user = Rxn<UserModel>();


  @override
  void onInit() {
    super.onInit();

    // 🔥 Load user from storage on app start
    final savedUser = storage.read('user');
    if (savedUser != null) {
      user.value = UserModel.fromJson(savedUser);
    }
  }



  Future<void> login() async {
    isLoading.value=true;
    try {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();

      final result = await authService.login(email, password);

      if (result != null) {
        //  Save user
        user.value = result;
        //  Save token
        storage.write('token', result.token);

        // Save user JSON
        storage.write('user', result.toJson());
        //save expiry time for token
        final expiryDate=DateTime.now().add(Duration(days: 365));
        storage.write('tokenExpiredDate', expiryDate.toIso8601String());

        // 🔥 CONNECT WEBSOCKET HERE
        WebSocketService().connect();

        // Navigate immediately
        Get.offAllNamed('/dashboard');

        Fluttertoast.showToast(
          msg: "Logged in successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.black87,
          textColor: Colors.white,
          fontSize: 16.0,
        );

      } else {
        Fluttertoast.showToast(
          msg: "Login Failed",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (error) {
      Fluttertoast.showToast(
        msg: "Error: ${error.toString()}",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    finally{
      isLoading.value=false;
    }
  }

  Future<void> logout() async {
    // Disconnect WebSocket
    WebSocketService().disconnect();

    // Clear local data
    user.value = null;
    await storage.erase();

    // Navigate to login
    Get.offAllNamed('/login');
  }


  String? get role=>user.value?.primaryRole;
}




