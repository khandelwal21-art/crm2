import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/bindings/auth_bindings.dart';
import 'package:nexuscrm/auth/screens/login_screen.dart';
import 'package:nexuscrm/bindings/autoCall_bindings.dart';
import 'package:nexuscrm/controller/myDrawer.dart';
import 'package:nexuscrm/screens/Incentive_widget.dart';
import 'package:nexuscrm/screens/autodialer_widget.dart';
import 'package:nexuscrm/screens/dash_screen.dart';
import 'package:nexuscrm/screens/timeSheet_screen.dart';

void main() {
  Get.put(MyDrawer());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Nexus CRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),

      initialRoute: '/login',
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
          binding: AuthBindings(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => DashScreen(),
          // No binding—just the view
        ),
        GetPage(
          name: '/timesheet',
          page: () => TimesheetScreen(),
          // No binding—just the view
        ),
        GetPage(
          name: '/autodialer',
          page: () => AutoDialerWidget(),
          binding: AutoCallBindings(),
        ),
        GetPage(
          name: '/incentives',
          page: () => IncentiveWidget(),
        ),
        // ...other routes
      ],
    );
  }
}


