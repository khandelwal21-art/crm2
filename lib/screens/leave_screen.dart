import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nexuscrm/config/theme.dart';
import 'package:nexuscrm/controller/leave_controller.dart';
import 'package:nexuscrm/widgets/glass_card.dart';
import 'package:nexuscrm/widgets/gradient_button.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import 'package:nexuscrm/widgets/modern_text_field.dart';

class LeaveScreen extends GetView<LeaveController> {
  const LeaveScreen({super.key});

  Color _statusColor(String status) {
    switch (status) {
      case "Approved": return Colors.green;
      case "Rejected": return Colors.red;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      extendBodyBehindAppBar: true, 
      appBar: const KAppBar(title: "My Leaves"),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showLeaveRequestDialog(context);
        },
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: AppTheme.backgroundLight,
          image: DecorationImage(
            image: NetworkImage("https://images.unsplash.com/photo-1614850523459-c2f4c699c52e?q=80&w=2670&auto=format&fit=crop"),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
               // _buildLeaveBalances(),
               Expanded(
                 child: Obx(() {
                    if (controller.leave.isEmpty) {
                      return Center(child: Text("No leave history found.", style: AppTheme.bodyText));
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: controller.leave.length,
                      separatorBuilder: (c, i) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final leave = controller.leave[index];
                        return GlassCard(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                     Text(DateFormat('MMM').format(DateTime.parse(leave.startDate!)), style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                     Text(DateFormat('dd').format(DateTime.parse(leave.startDate!)), style: AppTheme.heading2.copyWith(fontSize: 20)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("${leave.totalDays} Days", style: AppTheme.heading2.copyWith(fontSize: 16)),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: _statusColor(leave.status!).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: _statusColor(leave.status!).withOpacity(0.2))
                                          ),
                                          child: Text(
                                            leave.status!,
                                            style: TextStyle(
                                              color: _statusColor(leave.status!),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      leave.reason!,
                                      style: AppTheme.bodyText.copyWith(color: AppTheme.textPrimary),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${leave.startDate} - ${leave.endDate}",
                                      style: AppTheme.bodyText.copyWith(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                 }),
               )
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildLeaveBalances() {
  //   return SingleChildScrollView(
  //     scrollDirection: Axis.horizontal,
  //     padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
  //     child: Row(
  //       children: [
  //         _BalanceCard(label: "Casual Leave", used: 5, total: 12, color: Colors.blue),
  //         const SizedBox(width: 12),
  //         _BalanceCard(label: "Sick Leave", used: 2, total: 10, color: Colors.orange),
  //         const SizedBox(width: 12),
  //         _BalanceCard(label: "Provilage Leave", used: 0, total: 15, color: Colors.purple),
  //       ],
  //     ),
  //   );
  // }

  void _showLeaveRequestDialog(BuildContext context)
  {
    showGeneralDialog(
      context: context,
      barrierLabel: 'Leave Request',
      barrierDismissible: true,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(20),
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox( // Ensures content doesn't overflow
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8), 
                child: SingleChildScrollView(
                   child: _LeaveRequestForm(controller: controller),
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}

// class _BalanceCard extends StatelessWidget {
//   final String label;
//   final int used;
//   final int total;
//   final Color color;
//
//   const _BalanceCard({required this.label, required this.used, required this.total, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 140,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(6),
//                 decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
//                 child: Icon(Icons.pie_chart_rounded, size: 16, color: color),
//               ),
//               Text("$used / $total", style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textSecondary)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//           const SizedBox(height: 8),
//           LinearProgressIndicator(
//             value: used / total,
//             backgroundColor: color.withOpacity(0.1),
//             valueColor: AlwaysStoppedAnimation(color),
//             borderRadius: BorderRadius.circular(10),
//             minHeight: 6,
//           )
//         ],
//       ),
//     );
//   }
// }

class _LeaveRequestForm extends StatelessWidget {
  final LeaveController controller;
  const _LeaveRequestForm({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("New Request", style: AppTheme.heading2),
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close))
            ],
          ),
          const SizedBox(height: 20),

          Obx(()=> DropdownButtonFormField<String>(
            hint: Text("Select leave type"),
            value: controller.selectedLeaveType.value.isEmpty
                ?null
                :controller.selectedLeaveType.value,
                items: controller.leaveType.
                map((value)=> DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),

                )).toList(),
                onChanged: (value){
              controller.selectedLeaveType.value=value!;

                }),
          ),

          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: ModernTextField(
                  controller: controller.startDateController,
                  hintText: "Start Date",
                  prefixIcon: Icons.calendar_today_rounded,
                  validator: (v) => v!.isEmpty ? "Required" : null,
                  onTap: () async{
                     DateTime? pickedDate =await showDatePicker(
                        context: context,
                        //previous date which he can be selected 
                        initialDate:DateTime.now() ,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365))
                     );
                     if(pickedDate!=null){
                       controller.startDateController.text=DateFormat('yyyy-MM-dd').format(pickedDate);
                     }
                  },

                  // Tapping logic should be ideally handled by a DatePicker widget or inside ModernTextField logic for simplicity in this refactor
                  // Assuming logic remains connected via controller in a real app, but for UI refactor we keep structure
                ),
              ),
              const SizedBox(width: 12),
               Expanded(
                child: ModernTextField(
                  controller: controller.endDateController,
                  hintText: "End Date",
                   prefixIcon: Icons.calendar_today_rounded,
                   validator: (v) => v!.isEmpty ? "Required" : null,
                  onTap: () async{
                   DateTime? endDate= await showDatePicker(
                        context: context,
                        //previous date which he can be selected
                        initialDate:DateTime.now() ,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(Duration(days: 365)));

                   if(endDate!=null){
                     controller.endDateController.text=DateFormat('yyyy-MM-dd').format(endDate);
                   }
                  },
                ),
              ),
            ],
          ),
           const SizedBox(height: 16),
           
           ModernTextField(
             controller: controller.reasonController,
             hintText: "Reason for leave...",
             prefixIcon: Icons.edit_note_rounded,
             // maxLines: 4, // ModernTextField needs update to support maxLines if not present
             validator: (v) => v!.isEmpty ? "Required" : null,
           ),
           
           const SizedBox(height: 32),
           
           Obx(() => GradientButton(
             text: "Submit Request",
             isLoading: controller.isLoading.value,
             onPressed: () {
                if (controller.formKey.currentState!.validate()) {
                   controller.addLeave();
                }
             },
           )),
        ],
      ),
    );
  }
}