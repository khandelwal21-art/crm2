import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/dashBoard_controller.dart';
import 'package:nexuscrm/widgets/dashboard_stat_card.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/reusableCharts.dart';
import 'package:nexuscrm/config/theme.dart';

class AdminDashboardPage extends StatelessWidget {
   AdminDashboardPage({super.key});
  final DashBoardController chartController = Get.put(DashBoardController());

  final List<Map<String, dynamic>> cardItems = [
    {'icon': Icons.show_chart_rounded, 'color': Color(0xFF9C27B0), 'title': "Productivity", 'number': "85%"},
    {'icon': Icons.people_alt_rounded, 'color': Color(0xFF2196F3), 'title': "Staff Mgmt", 'number': "18"},
    {'icon': Icons.public_rounded, 'color': Color(0xFFFF9800), 'title': "Source", 'number': "100"},
    {'icon': Icons.work_outline_rounded, 'color': Color(0xFFF44336), 'title': "Freelancers", 'number': "7"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text("Dashboard Overview", style: AppTheme.heading2),
            const SizedBox(height: 20),

            // Stat Cards Grid
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.3,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: cardItems.length,
              itemBuilder: (context, index){
                final item = cardItems[index];
                return DashboardStatCard(
                  icon: item['icon'],
                  iconColor: item['color'],
                  title: item['title'],
                  value: item['number'],
                );
              },
            ),

            const SizedBox(height: 24),
            
            // Charts Section
            Text("Analytics", style: AppTheme.heading2.copyWith(fontSize: 20)),
            const SizedBox(height: 16),

            GlassCard(
              child: Column(
                children: [
                   ReusableChart(chartType:ChartType.bar,
                    title: "Productivity",
                    data: chartController.getBarChartData(),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: GlassCard(
                    child: ReusableChart(chartType:ChartType.pie,
                      title: "Staff",
                      data: chartController.getPieChartData(),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            GlassCard(
              child: ReusableChart(chartType:ChartType.pie,
                title: "Source Breakdown",
                data: chartController.getPieChartData(),
              ),
            ),
            
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }
}