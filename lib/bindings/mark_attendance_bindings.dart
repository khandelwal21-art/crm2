import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:nexuscrm/controller/mark_attendance_controller.dart';
import 'package:nexuscrm/services/mark_attendance_service.dart';

class MarkAttendanceBindings  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<MarkAttendanceService>(() => MarkAttendanceService());

    Get.lazyPut<MarkAttendanceController>(() => MarkAttendanceController());
  }

}