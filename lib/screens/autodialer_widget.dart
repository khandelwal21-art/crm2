import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:get/get.dart';
import 'package:nexuscrm/controller/autoCall-controller.dart';
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

  // final List<Map<String, dynamic>> numbers = [
  //   {'number': '6378603443', 'name': 'Shyam', 'isInterested': false},
  //   {'number': '9828271115', 'name': 'Amit', 'isInterested': false},
  //   {'number': '8929072576', 'name': 'Rohit', 'isInterested': false},
  //   {'number': '7689038247', 'name': 'Pooja', 'isInterested': false},
  //   {'number': '9893666707', 'name': 'Suman', 'isInterested': false},
  //   {'number': '6367686257', 'name': 'Alok', 'isInterested': false},
  //   {'number': '9521399708', 'name': 'Priya', 'isInterested': false},
  //   {'number': '7357842170', 'name': 'Ravi', 'isInterested': false},
  //   // Add more as needed
  // ];
  // List<Map<String,dynamic>> numbers=[];

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
            backgroundColor: Colors.white,
            shadowColor: Colors.black.withOpacity(0.1),

            // 💡 FIX: Wrap the title Row in a StatefulBuilder to make the Switch functional
            title: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Added alignment for better layout
                  children: [
                    Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start, // Added alignment
                      children: [
                        Text(
                          controller.numbers[currentIndex]['number'],
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(controller.numbers[currentIndex]['name']),
                      ],
                    ),
                    // 💡 FIX: Corrected syntax for the Switch
                    Switch(
                      value: dialogIsInterested,
                      onChanged: (value) {
                        dialogSetState(() {
                          dialogIsInterested = value;
                        });
                      },
                    ),
                  ],
                );
              },
            ),

            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter dialogSetState) {
                return DropdownButton<String>(
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
                );
              },
            ),

            actions: [
              TextButton(
                onPressed: () {
                  // Apply the dialog state back to the main widget's state before closing
                  setState(() {
                    controller.numbers[currentIndex]['isInterested'] =
                        dialogIsInterested;
                    selectedOption = dialogSelectedOption;
                  });

                  Navigator.of(context).pop();
                  dialogShown = false;
                  if (!callInProgress && isDialing) {
                    _moveToNextNumber();
                  }
                },
                child: Text('Ok'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isStreamError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Stream error occurred. Please restart the app.',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Number to call",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.deepOrangeAccent,
                        size: 22,
                      ),
                      const SizedBox(width: 12),

                      Text(
                        (controller.numbers.isEmpty ||
                                currentIndex >= controller.numbers.length)
                            ? "-"
                            : controller.numbers[currentIndex]['number'],
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(isDialing ? "Dialer Running..." : "Idle"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _toggleDialer,
                child: Text(
                  style: TextStyle(fontSize: 17),
                  isDialing ? 'Stop' : 'Start ',
                ),
              ),
            ),
            SizedBox(height: 15),

            Expanded(
              child: Obx(() {
                if (controller.numbers.isEmpty) {
                  return Center(child: CircularProgressIndicator());
                }

                // if statuses length mismatch -> rebuild it
                if (statuses.length != controller.numbers.length) {
                  statuses = List.filled(controller.numbers.length, 'Idle');
                }
                return ListView.builder(
                  itemCount: controller.numbers.length,
                  itemBuilder: (context, index) {
                    //getting status
                    final status = statuses.length > index
                        ? statuses[index]
                        : "Idle";

                    return Card(
                      elevation: 1,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.deepOrangeAccent,
                          size: 18,
                        ),
                        title: Text(
                          controller.numbers[index]['name'],
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(controller.numbers[index]['number']),
                        trailing: Text(
                          status,
                          style: TextStyle(
                            color: status == "Calling"
                                ? Colors.orange
                                : status == "Called"
                                ? Colors.green
                                : Colors.black,
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
    );
  }
}
