import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import 'package:nexuscrm/widgets/kDrawer.dart';
import '../auth/controller/auth_controller.dart';
import '../controller/mark_attendance_controller.dart';

class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreens> with SingleTickerProviderStateMixin {
  final controller = Get.find<MarkAttendanceController>();
  final authController = Get.find<AuthController>();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBodyBehindAppBar: true,
      appBar: const KAppBar(title: 'Mark Attendance'),
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundLight,
          image: DecorationImage(
             // Subtle background pattern
            image: NetworkImage("https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2670&auto=format&fit=crop"),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (controller.isLoading.value && controller.todayRecord == null) {
              return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
            }

            final record = controller.todayRecord;
            final checkIn = _formatTime(record?.checkIn);
            final checkOut = _formatTime(record?.checkOut);
            final totalHrs = controller.isCheckedIn.value
                ? _format(controller.liveWorkingHours.value)
                : record?.workingHours ?? _format(controller.liveWorkingHours.value);

            return Column(
              children: [
                // Top Section (Clock, Button, Stats)
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.55, // Fixed height for top section
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        
                        // Time & Date
                        Column(
                          children: [
                            Text(
                              controller.timeString.value,
                              style: AppTheme.heading1.copyWith(
                                fontSize: 42, 
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w300
                              ),
                            ),
                            Text(
                              controller.dateString.value,
                              style: AppTheme.bodyText.copyWith(fontSize: 16),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),

                        // Animated Check-In Button
                        GestureDetector(
                          onTap: controller.isLoading.value ? null : () async {
                             if (controller.isCheckedIn.value && authController.role=='super_user') {
                                final info = await _showCheckOutDialog();
                                if (info == null) return;
                                if (info['projectName']!.trim().isEmpty || info['workDescription']!.trim().isEmpty) {
                                  Get.snackbar("Error", "Please fill required fields", snackPosition: SnackPosition.BOTTOM);
                                  return;
                                }
                                await controller.toggleCheckInOut(checkOutInfo: info);
                              } else {
                                await controller.toggleCheckInOut();
                              }
                          },
                          child: ScaleTransition(
                            scale: _pulseAnimation,
                            child: Container(
                              height: 180,
                              width: 180,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: controller.isCheckedIn.value 
                                  ? LinearGradient(colors: [Color(0xFFEF5350), Color(0xFFC62828)]) // Red for Checkout
                                  : AppTheme.primaryGradient, // Green/Teal for Checkin
                                boxShadow: [
                                  BoxShadow(
                                    color: (controller.isCheckedIn.value ? Colors.red : AppTheme.primaryColor).withOpacity(0.4),
                                    blurRadius: 30,
                                    spreadRadius: 10,
                                  ),
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 20,
                                    offset: Offset(-5, -5)
                                  )
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.touch_app_rounded, 
                                    size: 40, 
                                    color: Colors.white.withOpacity(0.9)
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    controller.isCheckedIn.value ? "Check Out" : "Check In",
                                    style: AppTheme.heading2.copyWith(color: Colors.white, fontSize: 20),
                                  ),
                                  if (controller.isLoading.value) ...[
                                    const SizedBox(height: 12),
                                    const SizedBox(
                                      width: 24, height: 24,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Info Cards
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _InfoCard(label: "Check In", value: checkIn, icon: Icons.login_rounded, color: Colors.green),
                            _InfoCard(label: "Check Out", value: checkOut, icon: Icons.logout_rounded, color: Colors.red),
                            _InfoCard(label: "Working Hrs", value: totalHrs, icon: Icons.timer_rounded, color: Colors.orange),
                          ],
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                
                // Bottom History Section
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, -5),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Center( // Drag handle
                          child: Container(
                            width: 40,
                            height: 5,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Text(
                          "Attendance History",
                          style: AppTheme.heading2.copyWith(fontSize: 18),
                        ),
                        const SizedBox(height: 12),
                        
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 20),
                            itemCount: controller.history.length,
                            separatorBuilder: (c, i) => const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final item = controller.history[index];
                              return Container( // Simplified Card for history list
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.03),
                                      blurRadius: 5,
                                      offset: const Offset(0, 2)
                                    )
                                  ]
                                ),
                                child: Theme(
                                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                                    title: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        _ListColumn(label: "Date", value: item.date, isBold: true),
                                        _ListColumn(label: "In", value: _formatTime(item.checkIn)),
                                        _ListColumn(label: "Out", value: _formatTime(item.checkOut)),
                                      ],
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                        child: Column(
                                          children: [
                                            Divider(color: Colors.grey.withOpacity(0.1)),
                                            _DetailRow(label: "Status", value: item.status ?? '-'),
                                            _DetailRow(label: "Late Mins", value: "${item.lateMinutes ?? 0}"),
                                            _DetailRow(label: "Total Hrs", value: item.workingHours ?? '0:00'),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  String _formatTime(String? time) {
    if (time == null) return '--:--';
    return time.split('.').first;
  }
  
  String _format(Duration d) => d.toString().split('.').first;

  Future<Map<String, String>?> _showCheckOutDialog() async {
    final projectController = TextEditingController();
    final descriptionController = TextEditingController();
    final taskTimeController = TextEditingController();
    final progressController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Check Out Info", style: AppTheme.heading2.copyWith(fontSize: 20)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               _DialogInput(controller: projectController, label: "Project Name"),
               const SizedBox(height: 12),
               _DialogInput(controller: descriptionController, label: "Work Description", maxLines: 2),
               const SizedBox(height: 12),
               _DialogInput(controller: taskTimeController, label: "Task Time (e.g. 2h)"),
               const SizedBox(height: 12),
               _DialogInput(controller: progressController, label: "Progress (%)", isNumber: true),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: AppTheme.textSecondary)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context, {
                "projectName": projectController.text,
                "workDescription": descriptionController.text,
                "taskTime": taskTimeController.text,
                "workProgress": progressController.text,
              });
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _InfoCard({required this.label, required this.value, required this.icon, required this.color});

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

class _DialogInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;
  final bool isNumber;

  const _DialogInput({required this.controller, required this.label, this.maxLines=1, this.isNumber=false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}

class _ListColumn extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  const _ListColumn({required this.label, required this.value, this.isBold = false});

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

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppTheme.textSecondary)),
          Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
