import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/service/auth_service.dart';
import 'package:nexuscrm/models/user_model.dart';

class AuthContoller extends GetxController{

  final AuthService authService =Get.find();
  final TextEditingController emailController=TextEditingController();
  final TextEditingController passwordController=TextEditingController();

  var user = Rxn<UserModel>();

  Future<void> login()async {
    try {
      final result = await authService.loginApi(
           emailController.text, passwordController.text);
      if (result != null) {
        user.value = result;
        Get.toNamed("/dashboard");
      }
      else {
        print('Login failed—show error ');
      }
    } catch (error) {
      // Show exception error, e.g. network/server error
      Get.snackbar(
        "Error",
        error.toString(),
        backgroundColor: Get.theme.colorScheme.errorContainer,
        colorText: Get.theme.colorScheme.onErrorContainer,
      );
    }
  }

    String? get role=>user.value?.primaryRole;
  }




