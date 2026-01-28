import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/mark_attendance_controller.dart';

class DashboardScreens extends StatefulWidget {
  const DashboardScreens({super.key});

  @override
  State<DashboardScreens> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreens> {
  final controller = Get.find<MarkAttendanceController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Mark Attendance',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.todayRecord == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final record = controller.todayRecord;


        final checkIn = _formatTime(record?.checkIn);
        final checkOut = _formatTime(record?.checkOut);

        final totalHrs = controller.isCheckedIn.value
            ? _format(controller.liveWorkingHours.value)
            : record?.workingHours ??
            _format(controller.liveWorkingHours.value);

        return Column(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  //time
                  Text(controller.timeString.value,
                      style: const TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.bold)),
                  //date
                  Text(controller.dateString.value,
                      style: const TextStyle(color: Colors.grey,fontSize: 18,)),

                  const SizedBox(height: 30),

                  GestureDetector(
                    onTap: controller.isLoading.value
                        ? null
                        : () async {
                      if (controller.isCheckedIn.value) {
                        final info =
                        await _showCheckOutDialog();
                        if (info == null) return;
                        if (info['projectName']!.trim().isEmpty ||
                            info['workDescription']!.trim().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please fill all required fields",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        await controller.toggleCheckInOut(checkOutInfo: info);
                      }
                      else {
                        await controller.toggleCheckInOut();
                      }
                    },
                    child: Container(

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(width: 3, color: Colors.white),
                        boxShadow: [
                           BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          spreadRadius: 4,
                           blurRadius: 10
                          )
                        ]

                      ),
                      child: CircleAvatar(
                        radius: 90,
                        backgroundColor: Colors.teal,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                            color: Colors.white)
                            : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                                        controller.isCheckedIn.value
                                  ? "Check Out"
                                  : "Check In",
                                                        style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                                                      ),
                                Icon(Icons.touch_app,size: 33,color: Colors.white,)
                              ],
                            ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      _info("Check In", checkIn),
                      _info("Check Out", checkOut),
                      _info("Total Hrs", totalHrs),
                    ],

                  ),


                ],
              ),
            ),
            // 🔥 Attendance History Section
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      "Attendance History",
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.history.length,
                        itemBuilder: (context, index) {
                          final item = controller.history[index];

                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ExpansionTile(
                              title: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text("Date", style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500)),
                                      Text(item.date , style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Check In", style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500)),
                                      Text(_formatTime(item.checkIn), style: const TextStyle(color: Colors.black54)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("Check Out", style: const TextStyle(
                                          fontSize: 16, fontWeight: FontWeight.w500)),
                                      Text(_formatTime(item.checkOut),style: const TextStyle(color: Colors.black54) ),
                                    ],
                                  ),
                                ],
                              ),
                              children: [
                                ListTile(
                                  title: Text("Status: ${item.status ?? '-'}"),
                                ),
                                ListTile(
                                  title: Text(
                                      "Late Minutes: ${item.lateMinutes ?? 0}"),
                                ),
                                ListTile(
                                  title: Text(
                                      "Working Hours: ${item.workingHours ?? '0:00'}"),
                                ),
                              ],
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
    );
  }

  Widget _info(String label, String value) {
    return Column(
      children: [
        Text(value,
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
  String _formatTime(String? time) {
    if (time == null) return '00:00';
    return time.split('.').first;  // removes milliseconds
  }
  String _format(Duration d) =>
      d.toString().split('.').first;



  Future<Map<String, String>?> _showCheckOutDialog({
    Map<String, String>? checkOutInfo,}) async {
    final projectController = TextEditingController();
    final descriptionController = TextEditingController();
    final taskTimeController = TextEditingController();
    final progressController = TextEditingController();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Check Out Info"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: projectController,
                decoration: const InputDecoration(
                  labelText: "Project Name",
                ),
              ),
              const SizedBox(height: 12),

              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: "Work Description",
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: taskTimeController,
                decoration: const InputDecoration(
                  labelText: "Task Time (e.g. 2h)",
                ),
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 12),

              TextField(
                controller: progressController,
                decoration: const InputDecoration(
                  labelText: "Work Progress (%)",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
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
