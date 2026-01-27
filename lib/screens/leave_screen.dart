import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:intl/intl.dart';
import 'package:nexuscrm/controller/leave_controller.dart';
import 'package:nexuscrm/widgets/screen_widgets/my_text_field.dart';

class LeaveScreen extends GetView<LeaveController> {
  LeaveScreen({super.key});


  Color _statusColor(String status) {
    switch (status) {
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text("My Leaves"),
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          showGeneralDialog(context: context,
              barrierLabel: 'Leave Request',
              barrierDismissible: true,
              transitionDuration: Duration(milliseconds: 200),
              pageBuilder: (context, anim1, anim2) {
                return GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Scaffold(
                      backgroundColor: Colors.black.withOpacity(0.3),
                      body: Center(
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color:  Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: leaveRequestForm(context),
                        ),
                      ),
                    ),
                  ),
                );
              }
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Obx(() =>
          ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.leave.length,
            itemBuilder: (context, index) {
              final leave = controller.leave[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            leave.reason!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${leave.totalDays} days",
                            style: const TextStyle(
                                color: Colors.black, fontSize: 13),
                          ),
                          Row(
                            children: [
                              Text(
                                leave.startDate!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(width: 12,),
                              Text("-"),
                              SizedBox(width: 12,),
                              Text(
                                leave.endDate!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _statusColor(leave.status!),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        leave.status!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
      ),
    );
  }

  Widget? leaveRequestForm(BuildContext context) {
    return Form(
        key: controller.formKey,
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Leave Request",style: TextStyle(fontSize: 22,color: Colors.black54,)),
              SizedBox(height: 12,),
              MyTextField(
                controller: controller.leaveTypeController,
                keyboardType: TextInputType.multiline,
                labelText: "Leave Type",
                hintText: "Enter your reason for leave",
                maxLines: 7,
                minLines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter reason type";
                  }
                  else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 12,),
              MyTextField(
                controller: controller.startDateController,
                readOnly: true,
                hintText: 'Select start date',
                labelText: 'Start Date',
                onTap: () {
                  showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime
                          .now()
                          .year),
                      lastDate: DateTime(DateTime
                          .now()
                          .year + 1)).then((value) {
                            if(value!=null){
                              controller.startDateController.text = DateFormat('yyyy-MM-dd').format(value);

                            }
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please select start date";
                  }
                  else {
                    return null;
                  }
                }
              ),
              SizedBox(height: 12,),
              MyTextField(
                  controller: controller.endDateController,
                  readOnly: true,
                  hintText: 'Select end date',
                  labelText: 'End Date',
                  onTap: () {
                    showDatePicker(context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime
                            .now()
                            .year),
                        lastDate: DateTime(DateTime
                            .now()
                            .year + 1)).then((value)
                    {
                      if(value!=null){
                        controller.endDateController.text = DateFormat('yyyy-MM-dd').format(value);

                      }
                    });
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please select end date";
                    } else {
                      return null;
                    }
                  }

              ),
              SizedBox(height: 12,),
              MyTextField(
                controller: controller.reasonController,
                keyboardType: TextInputType.multiline,
                labelText: "Reason",
                hintText: "Enter your reason for leave",
                maxLines: 7,
                minLines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Please enter reason";
                  }
                  else {
                    return null;
                  }
                },
              ),
              SizedBox(height: 15,),
              SizedBox(
                height: 52,
                width: double.infinity,
                child: Obx( () => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : controller.addLeave,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child:controller.isLoading.value
                      ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ),
              ),

            ]
        )
    );
  }
}