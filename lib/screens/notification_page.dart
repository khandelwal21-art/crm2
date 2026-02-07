import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../controller/notification_controller.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final NotificationController nc = Get.put(NotificationController());

    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        actions: [
          TextButton(
            onPressed: nc.markAllRead,
            child: Text("Mark all read"),
          )
        ],
      ),
      body: Obx(() {
        return ListView.builder(
          itemCount: nc.notifications.length,
          itemBuilder: (context, index) {
            final n = nc.notifications[index];
            return ListTile(
              title: Text(n.title),
              subtitle: Text(n.message),
              trailing: n.isRead ? null : Icon(Icons.circle, color: Colors.red, size: 10),
            );
          },
        );
      }),
    );
  }
}
