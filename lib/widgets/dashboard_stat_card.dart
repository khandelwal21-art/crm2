import 'package:flutter/material.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/widgets/glass_card.dart';

class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int value;
  final Color? iconColor;
  final VoidCallback? onTap;

  const DashboardStatCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? AppTheme.secondaryColor).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor ?? AppTheme.secondaryColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value.toString(),
                  style: AppTheme.heading2.copyWith(fontSize: 22),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: AppTheme.bodyText.copyWith(fontSize: 15),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
