import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/myDrawer.dart';
import '../auth/controller/auth_controller.dart';
import 'kListTile.dart';
import 'package:nexuscrm/config/theme.dart';

class KDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  KDrawer({super.key, required this.menuItems});

  final MyDrawer drawerController = Get.find<MyDrawer>();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    // Theme consistency
    final Color drawerBackground = AppTheme.primaryColor;
    final Color activeColor = AppTheme.secondaryColor.withOpacity(0.3);
    final Color inactiveColor = Colors.transparent;

    return Drawer(
      width: 280,
      backgroundColor: drawerBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30)),
      ),
      child: Column(
        children: [
          // Custom Header with Gradient
          Container(
            padding: const EdgeInsets.only(top: 80, bottom: 40, left: 24, right: 24),
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(topRight: Radius.circular(30)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: AppTheme.secondaryColor,
                    child: Text(
                      authController.user.value?.name?.isNotEmpty == true
                          ? authController.user.value!.name![0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authController.user.value?.name ?? 'User',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          authController.role?.toUpperCase() ?? 'STAFF',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return Obx(() {
                  final selected = drawerController.selectedIndex.value == index;

                  if (item.containsKey('children')) {
                    final children = item['children'] as List<dynamic>;

                    return Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                        listTileTheme: const ListTileThemeData(
                          dense: true,
                          horizontalTitleGap: 0.0,
                          minVerticalPadding: 0,
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: selected ? Colors.white.withOpacity(0.03) : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ExpansionTile(
                          iconColor: Colors.white,
                          collapsedIconColor: Colors.white70,
                          backgroundColor: Colors.transparent,
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            item['title'],
                            style: TextStyle(
                              color: selected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                            ),
                          ),
                          leading: Icon(
                            item['icon'],
                            color: selected ? Colors.white : Colors.white70,
                            size: 20,
                          ),
                          children: children.map<Widget>((child) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16, bottom: 4), // Indent children
                              child: Klisttile(
                                leading: Icons.arrow_right, // Sub-item icon
                                title: child['title'],
                                backgroundColor: Colors.transparent, 
                                onTap: () {
                                  drawerController.selectIndex(index);
                                  Get.back();
                                  Get.toNamed(child['route']);
                                },
                              ),
                            );
                          }).toList(),
                          onExpansionChanged: (expanded) {
                            if (expanded) {
                              drawerController.selectIndex(index);
                            }
                          },
                        ),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Klisttile(
                      leading: item['icon'],
                      title: item['title'],
                      isSelected: selected,
                      backgroundColor: selected ? activeColor : inactiveColor,
                      onTap: () {
                        drawerController.selectIndex(index);
                        Get.back();
                        Get.toNamed(item['route']);
                      },
                    ),
                  );
                });
              },
            ),
          ),
          
          // Footer area (Logout or Version info could go here)
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text(
              "NexusCRM v1.0",
              style: TextStyle(color: Colors.white24, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
