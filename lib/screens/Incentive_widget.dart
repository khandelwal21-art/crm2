import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/config/menu.dart';
import 'package:nexuscrm/screens/pages/incentive/admin_incentive.dart';
import 'package:nexuscrm/screens/pages/incentive/staff_incentive.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import 'package:nexuscrm/widgets/kDrawer.dart';

class IncentiveWidget extends StatelessWidget {
  IncentiveWidget({Key? key}) : super(key: key);

  final AuthContoller authController = Get.find();
  //getting role
  late final String? role = authController.role;

  late final menu =roleMenus[role]??[];
  Widget build(BuildContext context) {
    Widget body;

    switch (role) {
      case "admin":
        body = AdminIncentive();
        break;
      case "staff":
        body = StaffIncentive();
        break;
      default:
        body = Center(child: Text('Unknown Role'));

    }
        return Scaffold(
      appBar: KAppBar(title: role?? " ",),
            drawer: KDrawer(menuItems: menu,),
      body: body
    );
  }
}
