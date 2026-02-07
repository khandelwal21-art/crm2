import "package:flutter/material.dart";
import "package:get/get_core/src/get_main.dart";
import "package:get/get_navigation/src/extension_navigation.dart";
import "package:nexuscrm/config/theme.dart";
import 'dart:ui';

import "../screens/notification_page.dart";

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const KAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent, // Transparent for body background visibility
      flexibleSpace: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.1)))
        ),
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      iconTheme: const IconThemeData(color: AppTheme.primaryColor),
      title: Text(
        title,
        style: AppTheme.heading2.copyWith(fontSize: 20),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Get.to(() => NotificationPage());
          },
          icon: const Icon(Icons.notifications_outlined, color: AppTheme.textSecondary),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}


