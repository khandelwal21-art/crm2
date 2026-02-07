import 'package:flutter/cupertino.dart';

import '../../../config/theme.dart';
import '../../../widgets/glass_card.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const InfoCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      width: 100,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value, style: AppTheme.heading2.copyWith(fontSize: 14)),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.bodyText.copyWith(fontSize: 10)),
        ],
      ),
    );
  }
}