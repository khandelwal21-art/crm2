import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/models/dashBoardItem.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import '../config/theme.dart';
import '../widgets/glass_card.dart';

class ProjectScreen extends StatelessWidget {
  final String title;
  final RxList<DashboardItem> listData;

  const ProjectScreen({
    super.key,
    required this.title,
    required this.listData,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case "completed":
      case "done":
        return Colors.green;
      case "on_hold":
        return Colors.blue;
      case "in_progress":
        return Colors.orange;
      case "cancel":
      case "blocked":
        return Colors.red;
      case "planned":
      case "todo":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: KAppBar(title: title),
        body: Obx(()=> ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: listData.length,
            itemBuilder: (context, index) {
              final project = listData[index];

              return GlassCard(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title + Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            project.title,
                            style: AppTheme.heading2.copyWith(fontSize: 18),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(project.status)
                                .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            project.status,
                            style: TextStyle(
                              color: _statusColor(project.status),
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      project.description,
                      style: AppTheme.bodyText.copyWith(
                        color: AppTheme.textSecondary,

                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 10),

                    // Dates

                    Text(
                      project.extra??" ",
                      style: AppTheme.bodyText.copyWith(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
