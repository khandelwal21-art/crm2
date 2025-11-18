import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/auth/service/auth_service.dart';


class AuthBindings extends Bindings{
  @override
  void dependencies() {
    //service
    Get.lazyPut<AuthService>(()=>AuthService());
    Get.lazyPut<AuthContoller>(()=>AuthContoller());

  }

}