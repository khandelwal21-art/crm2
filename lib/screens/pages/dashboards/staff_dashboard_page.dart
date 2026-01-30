import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/autoCall-controller.dart';
import 'package:nexuscrm/models/lead.dart';
import 'package:nexuscrm/widgets/dashboard_stat_card.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/modern_text_field.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/models/dashboard_extension.dart';

class StaffDashboardScreen extends StatelessWidget {

  StaffDashboardScreen({super.key});

  final AutoCallController controller = Get.find();

  final List<Lead> leads = [
    Lead(sn: 1, name: "Ravi Kumar", status: "Lead"),
    Lead(sn: 2, name: "Nisha Verma", status: "Interested"),
    Lead(sn: 3, name: "Ajay Solanki", status: "Lead"),
    Lead(sn: 4, name: "Rohit Sharma", status: "Converted"),
    Lead(sn: 5, name: "Sneha Gupta", status: "Pending"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: SafeArea(
        child: Obx((){
          final counts=controller.leads.value?.counts;
          final List<Map<String, dynamic>> cardItems = [
            {'icon': Icons.show_chart_rounded, 'color': Color(0xFF9C27B0), 'title': "Total Leads", 'number': counts?.totalLeads??0},
            {'icon': Icons.people_alt_rounded, 'color': Color(0xFF2196F3), 'title': "Total Interested Leads", 'number': counts?.totalInterestedLeads??0},
            {'icon': Icons.public_rounded, 'color': Color(0xFFFF9800), 'title': "Total Not Interested Leads", 'number':  counts?.totalNotInterestedLeads??0},
            {'icon': Icons.work_outline_rounded, 'color': Color(0xFFF44336), 'title': "Total Not Picked Leads", 'number':  counts?.totalNotPickedLeads??0},
          ];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Overview", style: AppTheme.heading2),
                const SizedBox(height: 16),

                // Stat Cards
                GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16
                    ),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cardItems.length,
                    itemBuilder: (context, index) {
                      final item = cardItems[index];
                      return DashboardStatCard(
                        icon: item['icon'],
                        iconColor: item['color'],
                        title: item['title'],
                        value: item['number'],
                      );
                    }
                ),

                const SizedBox(height: 24),

                // Search & Filter
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 50,
                        child: ModernTextField(
                          controller: TextEditingController(),
                          hintText: "Search leads...",
                          prefixIcon: Icons.search,
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
                                offset: Offset(0, 4)
                            )
                          ]
                      ),
                      child: IconButton(
                        onPressed: (){},
                        icon: Icon(Icons.filter_list, color: Colors.white),
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 24),
                Text("Recent Leads", style: AppTheme.heading2.copyWith(fontSize: 20)),
                const SizedBox(height: 12),

                // Leads List
                ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: leads.length,
                  separatorBuilder: (c, i) => SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final lead = leads[index];
                    return GlassCard(
                      padding: EdgeInsets.zero,
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                            child: Text(
                              lead.name[0],
                              style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(lead.name, style: AppTheme.bodyText.copyWith(color: AppTheme.textPrimary, fontWeight: FontWeight.bold)),
                          subtitle: Text(lead.status, style: TextStyle(
                              color: lead.status == "Converted" ? Colors.green :
                              lead.status == "Interested" ? Colors.orange : Colors.grey
                          )),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _ActionButton(icon: Icons.phone, label: "Call", color: Colors.blue),
                                  _ActionButton(icon: Icons.message, label: "Message", color: Colors.green),
                                  _ActionButton(icon: Icons.info_outline, label: "Details", color: Colors.grey),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 80),
              ],
            ),
          );
        },
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ActionButton({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
      ],
    );
  }
}
