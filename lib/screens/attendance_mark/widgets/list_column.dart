
import 'package:flutter/material.dart';

import '../../../config/theme.dart';

class ListColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const ListColumn({super.key, required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: AppTheme.textPrimary)),
      ],
    );
  }
}