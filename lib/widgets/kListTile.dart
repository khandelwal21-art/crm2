import 'package:flutter/material.dart';

class Klisttile extends StatelessWidget {
  final IconData leading;
  final String title;
  final IconData? trailingIcon;
  final VoidCallback onTap;
  final Color backgroundColor;


  const Klisttile({super.key,
    required this.leading,
    required this.title,
    required this.onTap,
    this.trailingIcon,
    required this.backgroundColor,



});

  @override
  Widget build(BuildContext context) {
    return
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Container(
            color: backgroundColor,
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                leading: Icon(leading, color:
              Colors.white,
              size: 16  ,
              ),
              title: Text(title,style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.w400
              ),
              ),
                 onTap: onTap,
              ),
            ),
        ),
      );



  }
}
