import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/myDrawer.dart';
import 'kListTile.dart';

class KDrawer extends StatelessWidget {
  final List<Map<String, dynamic>> menuItems;

  KDrawer({super.key, required this.menuItems});

  final MyDrawer drawerController = Get.find<MyDrawer>();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: Colors.black,
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              children: const [
                CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.touch_app, color: Colors.white),
                ),
                SizedBox(width: 15),
                Text(
                  "Admin@gmail.com",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];

                return Obx(() {
                  final selected =
                      drawerController.selectedIndex.value == index;

                  if (item.containsKey('children')) {
                    final children = item['children'] as List<dynamic>;

                    return Theme(
                      data: Theme.of(context)
                          .copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        backgroundColor:
                        selected ? Colors.orange : Colors.black,
                        title: Text(
                          item['title'],
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14),
                        ),
                        leading:
                        Icon(item['icon'], color: Colors.white, size: 16),
                        children: children.map<Widget>((child) {
                          return ListTile(
                            title: Text(
                              child['title'],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                            onTap: () {
                              drawerController.selectIndex(index);
                              Get.back();
                              Get.toNamed(child['route']);
                            },
                          );
                        }).toList(),
                        onExpansionChanged: (expanded) {
                          if (expanded) {
                            drawerController.selectIndex(index);
                          }
                        },
                      ),
                    );
                  }

                  return Klisttile(
                    leading: item['icon'],
                    title: item['title'],
                    backgroundColor:
                    selected ? Colors.orange : Colors.black,
                    onTap: () {
                      drawerController.selectIndex(index);
                      Get.back();
                      Get.toNamed(item['route']);
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
