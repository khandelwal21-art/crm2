import 'package:flutter/material.dart';

class TimesheetItem {
final String name;
final String email;
final String userType;
final String activityType;
final String ipAddress;
final String date;
final String description;

TimesheetItem({
  required this.name,
  required this.email,
  required this.userType,
  required this.activityType,
  required this.ipAddress,
  required this.date,
  required this.description,
});
}
class StaffTimeSheet extends StatefulWidget {
  const StaffTimeSheet({super.key});

  @override
  State<StaffTimeSheet> createState() => _StaffTimeSheetState();
}

class _StaffTimeSheetState extends State<StaffTimeSheet> {
  @override
  Widget build(BuildContext context) {
    int? openIndex;
    final List<TimesheetItem> items = [
      TimesheetItem(
        name: 'Ayush Sharma',
        email: 'Ayush720@gmail.com',
        userType: 'Staff User',
        activityType: 'Intrested',
        ipAddress: '127.0.0.1',
        date: '19/11/2025, 18:08:59',
        description: 'Lead status changed from Leads to Intrested by user [Email: ayush720@gmail.com, Staff User]',
      ),
      TimesheetItem(
        name: 'Ayush Sharma',
        email: 'Ayush720@gmail.com',
        userType: 'Staff User',
        activityType: 'Intrested',
        ipAddress: '127.0.0.1',
        date: '19/11/2025, 16:49:07',
        description: 'Lead status changed from Leads to Intrested.',
      ),
      TimesheetItem(
        name: 'Ayush Sharma',
        email: 'Ayush720@gmail.com',
        userType: 'Staff User',
        activityType: 'Intrested',
        ipAddress: '127.0.0.1',
        date: '19/11/2025, 16:37:47',
        description: 'Lead status changed from Leads to Intrested.',
      ),
      TimesheetItem(
        name: 'Ayush Sharma',
        email: 'Ayush720@gmail.com',
        userType: 'Staff User',
        activityType: 'Intrested',
        ipAddress: '127.0.0.1',
        date: '19/11/2025, 16:37:03',
        description: 'Lead status changed from Leads to Intrested.',
      ),
      TimesheetItem(
        name: 'Ayush',
        email: 'Ayush720@gmail.com',
        userType: 'Staff User',
        activityType: 'Intrested',
        ipAddress: '127.0.0.1',
        date: '19/11/2025, 11:58:54',
        description: 'Lead status changed.',
      ),
    ];

    return Scaffold(
      body: Container(
        color: Colors.grey[100],
        width: double.infinity,
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              width: 400,
              margin: EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              padding: EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.07),
                    blurRadius: 16,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Time Sheet',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Search Field
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.12),
                          blurRadius: 5,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search logs...',
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Timesheet Table with expansion logic
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
                            color: Colors.grey[50],
                          ),
                          child: Row(
                            children: [
                              Expanded(child: Text('S.N.', style: TextStyle(fontWeight: FontWeight.w600))),
                              Expanded(child: Text('Name', style: TextStyle(fontWeight: FontWeight.w600))),
                              Expanded(child: Text('Created Date', style: TextStyle(fontWeight: FontWeight.w600))),
                            ],
                          ),
                        ),
                        Divider(height: 1, color: Colors.grey),
                        ...List.generate(items.length, (i) {
                          final item = items[i];
                          final isOpen = openIndex == i;
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    openIndex = isOpen ? null : i;
                                  });
                                },
                                child: Container(
                                  color: isOpen ? Colors.grey[100] : Colors.white,
                                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Icon(isOpen ? Icons.remove : Icons.add, color: Colors.green, size: 22),
                                      SizedBox(width: 10),
                                      Expanded(child: Text(item.name, style: TextStyle())),
                                      Expanded(child: Text(item.date, style: TextStyle())),
                                    ],
                                  ),
                                ),
                              ),
                              if (isOpen)
                                Padding(
                                  padding: EdgeInsets.only(bottom: 12, left: 15, right: 15,top: 15),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.grey.shade300),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.08),
                                          blurRadius: 8,
                                          offset: Offset(0, 1),
                                        )
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                                          child: Text(item.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                                        ),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        _infoRow('Email:', item.email),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        _infoRow('User Type:', item.userType),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        _infoRow('Activity Type:', item.activityType),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        _infoRow('IP Address:', item.ipAddress),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        _infoRow('Created Date:', item.date),
                                        Divider(height: 1, color: Colors.grey.shade300),
                                        Padding(
                                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('Description:', style: TextStyle(fontWeight: FontWeight.w600)),
                                              SizedBox(height: 4),
                                              Text(item.description, style: TextStyle(color: Colors.grey[800])),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _infoRow(String label, String value) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.w500)),
        SizedBox(width: 8),
        Expanded(child: Text(value, style: TextStyle(color: Colors.grey[800]))),
      ],
    ),
  );
}