import 'package:get/get.dart';
import 'package:nexuscrm/controller/it_staff_dashboard_controller.dart';
import 'package:nexuscrm/services/it_staff_dashboard_service.dart';

class ItStaffDashboardBindings  extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>ItStaffDashboardService());
    Get.lazyPut(()=>ItStaffDashboardController());
  }

}