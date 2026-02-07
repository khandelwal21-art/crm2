import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nexuscrm/auth/bindings/auth_bindings.dart';
import 'package:nexuscrm/auth/screens/login_screen.dart';
import 'package:nexuscrm/bindings/autoCall_bindings.dart';
import 'package:nexuscrm/bindings/it_staff_dashboard_bindings.dart';
import 'package:nexuscrm/bindings/leave_bindings.dart';
import 'package:nexuscrm/bindings/mark_attendance_bindings.dart';
import 'package:nexuscrm/controller/myDrawer.dart';
import 'package:nexuscrm/screens/attendance_history_screen.dart';
import 'package:nexuscrm/screens/autodialer_widget.dart';
import 'package:nexuscrm/screens/attendance_mark/attendance_mark_screen.dart';
import 'package:nexuscrm/screens/dash_screen.dart';
import 'package:nexuscrm/screens/leave_screen.dart';

import 'auth/controller/auth_controller.dart';
import 'auth/service/auth_service.dart';
import 'config/theme.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  final storage = GetStorage();
  final token = storage.read('token');

  final initialRoute =
  token != null && !isTokenExpired(token)
      ? '/dashboard'
      : '/login';
  // register single instance only
  Get.put(AuthService(), permanent: true);
  Get.put(AuthController(), permanent: true);
    Get.put(MyDrawer(), permanent: true);
  runApp(MyApp(initialRoute: initialRoute));
}

//check if the token is expired or not
bool isTokenExpired(String token) {
  final expiry=GetStorage().read('tokenExpiredDate');
  if(expiry==null) return true;

  return DateTime.now().isAfter(DateTime.parse(expiry));

}

class MyApp extends StatelessWidget {
  final String initialRoute;
   const MyApp({super.key,required this.initialRoute});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AutoCallBindings(),
      initialRoute: initialRoute,
      getPages: [
        GetPage(
          name: '/login',
          page: () => LoginScreen(),
        ),
        GetPage(
          name: '/dashboard',
          page: () => DashScreen(),
          binding: ItStaffDashboardBindings()
          // No binding—just the view
        ),
        GetPage(
          name: '/mark-attendance',
          page: () => DashboardScreens(),
          binding: MarkAttendanceBindings(),

          // No binding—just the view
        ),
        GetPage(
          name: '/attendance-history',
          page: () => AttendanceHistoryScreen(),
          // No binding—just the view
        ),
        GetPage(
          name: '/leave-screen',
          page: () => LeaveScreen(),
          binding: LeaveBindings()
          // No binding—just the view
        ),
        GetPage(
          name: '/autodialer',
          page: () => AutoDialerWidget(),
          binding: AutoCallBindings(),
        ),
        // GetPage(name: '/itStaffDashBoard',
        //     page:()=> ItStaffDashboardPage(),
        //   binding: ItStaffDashboardBindings()
        //
        // )

        // ...other routes
      ],
    );
  }
}


