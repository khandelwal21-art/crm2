//   import 'package:flutter/material.dart';
//   import 'package:get/get.dart';
//   import 'package:get/get_core/src/get_main.dart';
//   import 'package:nexuscrm/controller/myDrawer.dart';
//   import 'package:nexuscrm/screens/addSell_screen.dart';
//   import 'package:nexuscrm/screens/dashboard_screen.dart';
//   import 'package:nexuscrm/screens/autodialer_widget.dart';
//   import 'package:nexuscrm/screens/marketing_screen.dart';
//   import 'package:nexuscrm/screens/productivity_screen.dart';
//   import 'package:nexuscrm/screens/project_screen.dart';
//   import 'package:nexuscrm/screens/timeSheet_screen.dart';
//   import 'package:nexuscrm/screens/user_screen.dart';
// import 'package:nexuscrm/widgets/kAppBar.dart';
//   import 'package:nexuscrm/widgets/kIconBtn.dart';
//   import 'package:nexuscrm/widgets/screen_widgets/kDrawer.dart';
//
//   class WidgetTree extends StatefulWidget {
//     const WidgetTree({Key? key}) : super(key: key);
//
//     @override
//     State<WidgetTree> createState() => _WidgetTreeState();
//   }
//
//   class _WidgetTreeState extends State<WidgetTree> {
//     final DrawerControllers drawerController = Get.put(DrawerControllers());
//
//     final List<Widget> screens = [
//       DashboardScreen(),
//       UserScreen(),
//       ProductivityScreen(),
//       MarketingScreen(),
//       TimesheetScreen(),
//       ProjectScreen(),
//       AddSellScreen(),
//     ];
//
//     void _onDrawerTap(int parentIndex, int? childIndex) {
//
//       if (parentIndex == 3) {
//         Get.toNamed('/autodialer');   // AUTO BINDINGS RUN
//         return;
//       }
//         drawerController.selectedIndex.value = parentIndex;
//         drawerController.selectedChildIndex.value = childIndex;
//       Navigator.pop(context); // Close drawer
//     }
//
//     @override
//     Widget build(BuildContext context) {
//       return Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar:KAppBar(title: "admin",),
//         drawer: Drawer(
//           width: 250,
//           backgroundColor: Colors.black,
//           child: Kdrawer(
//             selectedIndex: drawerController.selectedIndex.value,
//             onItemTap: _onDrawerTap,
//           ),
//         ),
//         body: Obx(() =>
//         screens[drawerController.selectedIndex.value]),
//       );
//     }
//   }
//
