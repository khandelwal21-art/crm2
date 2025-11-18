import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/config/menu.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
      if (role == "admin") {
        Get.off(() => AdminDashboardPage());
      } else {
        Get.off(() => StaffDashboardScreen());
      }
    });
    return Scaffold(
      appBar: KAppBar(title: role?? " ",),
      drawer: KDrawer(menuItems: menu,)

    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: Center(child: Text("Welcome Admin!")),
    );
  }
}
class StaffDashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Staff Dashboard")),
      body: Center(child: Text("Welcome Staff!")),
    );
  }
}
