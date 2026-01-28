import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/auth/controller/auth_controller.dart';
import 'package:nexuscrm/config/menu.dart';
import 'package:nexuscrm/controller/autoCall-controller.dart';
import 'package:nexuscrm/widgets/kAppBar.dart';
import 'package:nexuscrm/widgets/kDrawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:phone_state/phone_state.dart';

class AutoDialerWidget extends StatefulWidget {
  @override
  State<AutoDialerWidget> createState() => _AutoDialerWidgetState();
}

class _AutoDialerWidgetState extends State<AutoDialerWidget> {
  static const EventChannel _phoneStateEventChannel = EventChannel(
    'com.example.phone_state/events',
  );
  late AutoCallController controller;

  bool isLoading = true;
  bool callInProgress = false;
  List<String> statuses = [];
  int currentIndex = 0;
  bool isDialing = false;
  PhoneStateStatus? lastState;
  bool callHandled = false;
  bool isStreamError = false;
  bool dialogShown = false;
  List<String> dropdownItems = ['Vrindavan', 'Radhe Krishna', 'Jaipur '];
  String selectedOption = 'Vrindavan';
  bool isInterested = false;

  final AuthController authController = Get.find();
  //getting role
  late final String? role = authController.role;

  late final menu =roleMenus[role]??[];

  @override
  void initState() {
    super.initState();
    controller = Get.find<AutoCallController>();
  }

  // Future<void> fetchNumbersFromApi() async {
  //   const url = 'https://crm.sudotechlabs.com/accounts/api/admin-leads/total_upload_lead_tag/';
  //   final sessionId = 'k7fuutc4l91rs1xpwyppif5k79ywpdjo';
  //   try {
  //     final response = await http.get(Uri.parse(url),
  //       headers: {
  //       'Cookie': 'sessionid=$sessionId',
  //       'Content-Type': 'application/json',
  //       },);
  //     print(response.body);
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       final List<dynamic> results = jsonResponse['results'];
  //
  //       // Map results to your list of maps with keys 'number', 'name', and default 'isInterested'
  //       final List<Map<String, dynamic>> fetchedNumbers = results.map((item) {
  //         return {
  //           'number': item['call'],
  //           'name': item['name'],
  //           'isInterested': false, // Default false; you can update later
  //         };
  //       }).toList();
  //
  //       setState(() {
  //         numbers = fetchedNumbers;
  //         isLoading = false;
  //       });
  //     } else {
  //       setState(() => isLoading = false);
  //       print('Failed to fetch data. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     setState(() => isLoading = false);
  //     print('Error fetching data: $e');
  //   }
  // }

  void _startListeningPhoneState() {
    _phoneStateEventChannel.receiveBroadcastStream().listen(
      (event) {
        _handlePhoneStateChange(event);
      },
      onError: (error) {
        print("Phone state stream error: $error");
        setState(() {
          isStreamError = true;
        });
      },
    );
  }

  Future<bool> _requestPermission() async {
    var status = await Permission.phone.status;
    if (!status.isGranted) {
      status = await Permission.phone.request();
    }

    return status.isGranted;
  }

  void _toggleDialer() async {
    if (!isDialing) {
      bool granted = await _requestPermission();
      if (!granted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Phone permission is required to start dialing'),
          ),
        );
        return;
      }
      _startListeningPhoneState();

      setState(() {
        isDialing = true;
        currentIndex = 0;
        callHandled = false;
        statuses = List.filled(controller.numbers.length, 'Idle');
        isStreamError = false;
      });
      // slight delay before first call
      Future.delayed(const Duration(milliseconds: 300), _callCurrentNumber);
    } else {
      setState(() {
        isDialing = false;
      });
    }
  }

  void _callCurrentNumber() async {
    if (currentIndex < controller.numbers.length && isDialing) {
      setState(() {
        statuses[currentIndex] = 'Calling'; // Mark the number as calling here
        callInProgress = true;
      });
      try {
        await FlutterPhoneDirectCaller.callNumber(
          controller.numbers[currentIndex]['number'],
        );
      } catch (e) {
        print("Error calling number: $e");
        setState(() {
          statuses[currentIndex] = 'Failed';
          callInProgress = false;
        });
      }
    }
  }

  void _handlePhoneStateChange(dynamic state) {
    if (state == 'CALL_STARTED' && !dialogShown) {
      dialogShown = true;
      callInProgress = true;

      showDialog(
        context: context,
        builder: (context) {
          // Local state for the dialog
          bool dialogIsInterested = isInterested;
          String dialogSelectedOption = selectedOption;

          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.phone_in_talk, color: Colors.orange, size: 30),
                ),
                SizedBox(height: 12),
                Text(
                  "Call Details",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        controller.numbers[currentIndex]['name'] ?? "Unknown",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(controller.numbers[currentIndex]['number'] ?? ""),
                      trailing: Switch(
                        activeColor: Colors.green,
                        value: dialogIsInterested,
                        onChanged: (value) {
                          dialogSetState(() {
                            dialogIsInterested = value;
                          });
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Interested?", style: TextStyle(color: Colors.grey[600])),
                        Text(
                          dialogIsInterested ? "YES" : "NO",
                          style: TextStyle(
                            color: dialogIsInterested ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: dialogSelectedOption,
                          items: dropdownItems.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            dialogSetState(() {
                              dialogSelectedOption = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            actions: [
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    setState(() {
                      controller.numbers[currentIndex]['isInterested'] = dialogIsInterested;
                      selectedOption = dialogSelectedOption;
                    });
                    Navigator.of(context).pop();
                    dialogShown = false;
                    if (!callInProgress && isDialing) {
                      _moveToNextNumber();
                    }
                  },
                  child: Text('Save & Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          );
        }, // End of showDialog builder
      );
    }

    if (state == 'CALL_ENDED' && callInProgress) {
      callHandled = true;
      setState(() {
        statuses[currentIndex] = 'Called';
        callInProgress = false;
      });

      if (!dialogShown) {
        Future.delayed(Duration(seconds: 5), () {
          if (!isDialing) return;
          _moveToNextNumber();
        });
      }
    }
  }

  void _moveToNextNumber() {
    if (currentIndex < controller.numbers.length) {
      setState(() {
        currentIndex++;
        statuses[currentIndex] = 'Calling';
      });
      _callCurrentNumber();
    } else {
      setState(() => isDialing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ All numbers called successfully.")),
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Calling':
        return Colors.orange;
      case 'Called':
        return Colors.green;
      case 'Failed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Calling':
        return Icons.ring_volume;
      case 'Called':
        return Icons.check_circle_outline;
      case 'Failed':
        return Icons.error_outline;
      default:
        return Icons.schedule;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: KAppBar(title: role?? " ",),
      drawer: KDrawer(menuItems: menu,),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey[50],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isStreamError)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Stream error occurred. Please restart the app.',
                          style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                ),

              // Active Dialer Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.indigo.withOpacity(0.3),
                      blurRadius: 15,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "CURRENT SESSION",
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              isDialing ? "Dialing Active" : "Standby Mode",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: isDialing ? Colors.greenAccent : Colors.orangeAccent,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                isDialing ? "RUNNING" : "IDLE",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Colors.indigo[700],
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Phone Number",
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 12,
                                  ),
                                ),
                                Text(
                                  (controller.numbers.isEmpty ||
                                          currentIndex >= controller.numbers.length)
                                      ? "None Scheduled"
                                      : controller.numbers[currentIndex]['number'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              // Action Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDialing ? Colors.redAccent : Colors.orange[800],
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor: (isDialing ? Colors.redAccent : Colors.orange).withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _toggleDialer,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(isDialing ? Icons.stop_rounded : Icons.play_arrow_rounded, size: 28),
                      SizedBox(width: 8),
                      Text(
                        isDialing ? 'STOP DIALER' : 'START AUTO DIALER',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(height: 24),
              
              Text(
                "UPCOMING CALLS",
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 12),

              Expanded(
                child: Obx(() {
                  if (controller.numbers.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.indigo),
                          SizedBox(height: 16),
                          Text("Fetching leads...", style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    );
                  }

                  if (statuses.length != controller.numbers.length) {
                    statuses = List.filled(controller.numbers.length, 'Idle');
                  }
                  
                  return ListView.separated(
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: controller.numbers.length,
                    separatorBuilder: (context, index) => SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final status = statuses.length > index ? statuses[index] : "Idle";
                      final isCurrent = index == currentIndex && isDialing;
                      
                      return AnimatedContainer(
                        duration: Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isCurrent ? Colors.indigo[50] : Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isCurrent ? Colors.indigo[200]! : Colors.transparent,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getStatusIcon(status),
                              color: _getStatusColor(status),
                              size: 20,
                            ),
                          ),
                          title: Text(
                            controller.numbers[index]['name'] ?? "Unknown Lead",
                            style: TextStyle(
                              fontWeight: isCurrent ? FontWeight.bold : FontWeight.w600,
                              fontSize: 15,
                              color: isCurrent ? Colors.indigo[900] : Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            controller.numbers[index]['number'],
                            style: TextStyle(color: Colors.grey[600], fontSize: 13),
                          ),
                          trailing: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: TextStyle(
                                color: _getStatusColor(status),
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
