import 'package:flutter/material.dart';

class KIconBtn extends StatelessWidget {
  final IconData icons;
  final VoidCallback? onPressed;
  final double size;
  final Color color;

  const KIconBtn(
      {super.key,
        required this.icons,
        required this.onPressed,
        this.size=14,
        this.color=Colors.black,

      });

  @override
  Widget build(BuildContext context) {
    return IconButton(onPressed: onPressed,
        icon:Icon(icons,
          size: size,
          color: color,
        ) ,
    );
  }
}

