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
import 'package:nexuscrm/screens/attendance_mark_screen.dart';
import 'package:nexuscrm/screens/dash_screen.dart';
import 'package:nexuscrm/screens/leave_screen.dart';
import 'package:nexuscrm/screens/pages/dashboards/it_staff_dashboard_page.dart';

import 'auth/controller/auth_controller.dart';
import 'auth/service/auth_service.dart';
import 'config/theme.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
   Get.put(MyDrawer());
  Get.put(AuthService(), permanent: true);
  Get.put(AuthController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'CRM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialBinding: AutoCallBindings(),
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


