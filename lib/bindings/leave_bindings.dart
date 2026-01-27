import 'package:get/get.dart';
import 'package:nexuscrm/services/leave_service.dart';

import '../controller/leave_controller.dart';

class LeaveBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>LeaveService());
    Get.lazyPut(() => LeaveController());
  }
}