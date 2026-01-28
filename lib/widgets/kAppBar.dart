import "package:flutter/material.dart";
import "package:nexuscrm/widgets/kIconBtn.dart";

class KAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const KAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: false,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
        // flexibleSpace: Container(
        //   padding: const EdgeInsets.only(left: 55),
        //   width: double.infinity,
        //   color: Colors.white,
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       // Center Title
        //
        //       ),
        //       // Action Icons
        //       Padding(
        //         padding: const EdgeInsets.only(right: 16.0),
        //         child: Row(
        //           children: [
        //             KIconBtn(
        //               icons: Icons.light_mode,
        //               onPressed: () {},
        //             ),
        //             const SizedBox(width: 8),
        //             KIconBtn(
        //               icons: Icons.notification_add_outlined,
        //               onPressed: () {},
        //             ),
        //           ],
        //         ),
        //       ),
        //     ],
        //   ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(85.0);
}
