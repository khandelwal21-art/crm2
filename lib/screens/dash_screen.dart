import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/config/menu.dart';
import 'package:nexuscrm/screens/pages/dashboards/admin_dashboard-page.dart';
import 'package:nexuscrm/screens/pages/dashboards/staff_dashboard_page.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import 'package:nexuscrm/widgets/kDrawer.dart';

class DashScreen extends StatelessWidget {
   DashScreen({super.key});

  final AuthContoller authController = Get.find();
  //getting role
 late final String? role = authController.role;

 late final menu =roleMenus[role]??[];

  @override
  Widget build(BuildContext context) {
    Widget body;

    switch (role) {
      case "admin":
        body = AdminDashboardPage();
        break;
      case "staff":
        body = StaffDashboardScreen();
        break;
      default:
        body = Center(child: Text('Unknown Role'));

    }
    return Scaffold(
      appBar: KAppBar(title: role?? " ",),
      drawer: KDrawer(menuItems: menu,),
      body: body,


    );
  }
}


