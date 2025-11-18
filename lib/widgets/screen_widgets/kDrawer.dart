// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:nexuscrm/controller/myDrawer.dart';
// import 'package:nexuscrm/widgets/kListTile.dart';
//
// class Kdrawer extends StatelessWidget {
//   final DrawerControllers drawerController = Get.find();
//   final void Function(int parentIndex, int? childIndex) onItemTap;
//
//   Kdrawer({Key? key, required this.onItemTap, require, required  int selectedIndex}) : super(key: key);
//
//   final List<Map<String, dynamic>> drawerItems = [
//     {'icon': Icons.dashboard_outlined, 'title': "Dashboard"},
//     {
//       'icon': Icons.person_2_outlined,
//       'title': "User",
//       'children': ['Profile', 'Settings', 'Logout'],
//     },
//     {
//       'icon': Icons.bar_chart_outlined,
//       'title': "Productivity",
//       'children': ['Report 1', 'Report 2'],
//     },
//     {
//       'icon': Icons.assignment_outlined,
//       'title': "Leads Report",
//       'children': ['Auto Call', 'Lead 2'],
//     },
//     {
//       'icon': Icons.campaign_outlined,
//       'title': "Marketing",
//       'children': ['Campaign 1', 'Campaign 2'],
//     },
//     {'icon': Icons.access_time_outlined, 'title': "Time Sheet"},
//     {'icon': Icons.work_outline, 'title': "Project"},
//     {'icon': Icons.sell_outlined, 'title': "Add Sell"},
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         const Padding(
//           padding: EdgeInsets.all(18.0),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: Colors.orange,
//               child: Icon(Icons.touch_app, color: Colors.white),
//             ),
//             title: Text(
//               "Super Admin",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
//             ),
//           ),
//         ),
//         Expanded(
//           child: Obx(() {
//             final selectedParent = drawerController.selectedIndex.value;
//             final selectedChild = drawerController.selectedChildIndex.value;
//
//             return ListView.builder(
//               itemCount: drawerItems.length,
//               itemBuilder: (context, index) {
//                 final item = drawerItems[index];
//                 final isParentSelected = (selectedParent == index) && (selectedChild == null);
//                 final isExpanded = isParentSelected;
//
//                 if (item.containsKey('children')) {
//                   return Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     decoration: BoxDecoration(
//                       color: isParentSelected ? Colors.orange : Colors.black,
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Theme(
//                       data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
//                       child: ExpansionTile(
//                         key: Key(index.toString()),
//                         leading: Icon(item['icon'], color: Colors.white, size: 16),
//                         title: Text(item['title'],
//                             style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
//                         iconColor: Colors.white,
//                         collapsedIconColor: Colors.white,
//                         initiallyExpanded: isExpanded,
//                         onExpansionChanged: (expanded) {
//                           if (expanded) {
//                             drawerController.selectParent(index);
//                             onItemTap(index, null);
//                           } else {
//                             drawerController.selectedChildIndex.value = null;
//                           }
//                         },
//                         children: [
//                           for (int childIndex = 0; childIndex < item['children'].length; childIndex++)
//                             ListTile(
//                               title: Text(item['children'][childIndex],
//                                   style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w400)),
//                               tileColor: (selectedParent == index && selectedChild == childIndex) ? Colors.orange : Colors.black,
//                               onTap: () {
//                                 drawerController.selectChild(index, childIndex);
//                                 onItemTap(index, childIndex);
//                               },
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//
//                 return GestureDetector(
//                   onTap: () {
//                     drawerController.selectParent(index);
//                     onItemTap(index, null);
//                   },
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
//                     // child: Klisttile(
//                     //   leading: item['icon'],
//                     //   title: item['title'],
//                     //   selected: isParentSelected,
//                     // ),
//                   ),
//                 );
//               },
//             );
//           }),
//         )
//       ],
//     );
//   }
// }
