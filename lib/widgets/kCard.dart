import 'package:flutter/material.dart';

class Kcard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String  number;
  const Kcard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.number

  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon,size: 18,color: color,),
          SizedBox(height: 5,),
          Text(title,style:
          TextStyle(fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w500

          ),
          ),
          SizedBox(height: 5,),

          Text(number,
            style:TextStyle(
                fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400
          ),
          )
        ],
      ),

    );
  }
}
