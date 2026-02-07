import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/it_staff_dashboard_controller.dart';
import 'package:nexuscrm/widgets/dashboard_stat_card.dart';
import 'package:nexuscrm/widgets/modern_text_field.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/models/dashBoardItem.dart';

import '../../../models/dashboard_extension.dart';
import '../../../widgets/glass_card.dart';
import '../../project_screen.dart';

class ItStaffDashboardPage extends StatelessWidget {
  ItStaffDashboardPage({super.key});

  final ItStaffDashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Overview", style: AppTheme.heading2),
              const SizedBox(height: 16),

              // Stat Cards
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.cardItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cardItems[index];

                  return Obx(() {
                    int value = 0;

                    if (item['title'] == 'Total Projects') {
                      value = controller.totalProjects.value;
                    } else if (item['title'] == "Total Tasks") {
                      value = controller.totalTasks.value;
                    } else if (item['title'] == "Total Completed Tasks") {
                      value = controller.completedTasksCount.value;
                    } else if (item['title'] == "Total Pending tasks") {
                      value = controller.pendingTasksCount.value;
                    }

                    return DashboardStatCard(
                      icon: item['icon'],
                      iconColor: item['color'],
                      title: item['title'],
                      value: value,
                      onTap: () {
                        if (item['title'] == "Total Projects") {
                          final list = controller.getProjectList()
                              .map((e) => e.toDashboardItem())
                              .toList();

                          Get.to(() => ProjectScreen(
                            title: item['title'],
                            listData:controller.projectItems,
                          ));
                        }

                        if (item['title'] == "Total Tasks") {
                          final list = controller.getTaskList()
                              .map((e) => e.toDashboardItem())
                              .toList();

                          Get.to(() => ProjectScreen(
                            title: item['title'],
                            listData: list.obs,
                          ));
                        }

                        if (item['title'] == "Total Pending tasks") {
                          final list = controller.getPendingTaskList()
                              .map((e) => e.toDashboardItem())
                              .toList();

                          Get.to(() => ProjectScreen(
                            title: item['title'],
                            listData: list.obs,
                          ));
                        }

                        if (item['title'] == "Total Completed Tasks") {
                          final list = controller.getCompletedTaskList()
                              .map((e) => e.toDashboardItem())
                              .toList();

                          Get.to(() => ProjectScreen(
                            title: item['title'],
                            listData: list.obs,
                          ));
                        }
                      },
                    );
                  });
                },
              ),

              const SizedBox(height: 24),

              // Search & Filter
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ModernTextField(
                        controller:controller.searchController,
                        hintText: "Search leads...",
                        prefixIcon: Icons.search,
                        onChanged:(value){
                          controller.updateFilteredProject(value);
                        },
                        
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.filter_list, color: Colors.white),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 24),

              Text("Recent Projects",style:TextStyle(color: Colors.black45,fontWeight: FontWeight.w500,fontSize: 20),),
              // Recent Projects
              Obx(() {
                final recent = controller.filteredProjects;

                if (recent.isEmpty) {
                  return Center(child: const Text("No recent projects found"));
                }

                return ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: recent.length,
                  separatorBuilder: (c, i) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final project = recent[index];

                    return GlassCard(
                      padding: EdgeInsets.zero,
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor:
                            AppTheme.primaryColor.withOpacity(0.1),
                            child: Text(
                              project.name[0],
                              style: TextStyle(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            project.name,
                            style: AppTheme.bodyText.copyWith(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            project.status,
                            style: TextStyle(
                              color: project.status == "Completed"
                                  ? Colors.green
                                  : project.status == "In Progress"
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                          ),
                          children: [
                            Padding(
                              padding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: const [
                                  _ActionButton(
                                      icon: Icons.phone,
                                      label: "Call",
                                      color: Colors.blue),
                                  _ActionButton(
                                      icon: Icons.message,
                                      label: "Message",
                                      color: Colors.green),
                                  _ActionButton(
                                      icon: Icons.info_outline,
                                      label: "Details",
                                      color: Colors.grey),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
