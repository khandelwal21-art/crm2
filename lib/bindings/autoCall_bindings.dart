import 'package:get/get.dart';
import 'package:nexuscrm/controller/autoCall-controller.dart';
import 'package:nexuscrm/services/autoCall-services.dart';

class AutoCallBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AutoCallService>(() => AutoCallService());

    Get.lazyPut<AutoCallController>(() => AutoCallController());

  }

}