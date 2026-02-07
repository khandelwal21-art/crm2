import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nexuscrm/screens/pages/dashboards/admin_dashboard-page.dart';
import 'package:nexuscrm/screens/pages/dashboards/it_staff_dashboard_page.dart';
import 'package:nexuscrm/screens/pages/dashboards/staff_dashboard_page.dart';

import '../auth/controller/auth_controller.dart';
import '../config/menu.dart';
import '../widgets/kAppBar.dart';
import '../widgets/kDrawer.dart';

class DashScreen extends StatelessWidget {
  DashScreen({super.key});

  final AuthController authController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final role = authController.role ?? 'unknown';
      final menu = roleMenus[role] ?? [];

      Widget body;
      switch (role) {
        case "admin":
          body = AdminDashboardPage();
          break;
        case "staff":
          body = StaffDashboardScreen();
          break;
        case "it_staff":
          body = ItStaffDashboardPage();
          break;
        default:
          body = Center(child: Text('Unknown Role'));
      }

      return Scaffold(
        appBar: KAppBar(title: role),
        drawer: KDrawer(menuItems: menu),
        body: body,
      );
    });
  }
}
