import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../models/attendance_record.dart';
import '../services/mark_attendance_service.dart';

class MarkAttendanceController extends GetxController
{
  final MarkAttendanceService _locationService = Get.find();
  /// Reactive state
  var isLoading = false.obs;
  var isCheckedIn = false.obs;
// Location state
  var latitude = 0.0.obs;
  var longitude = 0.0.obs;
  var address = ''.obs;
  var history = <AttendanceRecord>[].obs;
  AttendanceRecord? todayRecord;

  var liveWorkingHours = Duration.zero.obs;

  // ⏰ Clock values
  var timeString = ''.obs;
  var dateString = ''.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
     loadAttendance();
    startClock();
  }

  @override
  void onClose() {
    stopClock();
    super.onClose();
  }

  void startClock() {
    _updateClock();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _updateClock();
      updateLiveHours();
    });
  }

  void stopClock() {
    _timer?.cancel();
  }

  void _updateClock() {

    final now = DateTime.now().toUtc().add(Duration(hours: 5,minutes: 30));
    timeString.value = DateFormat('h:mm:ss a').format(now);
    dateString.value = DateFormat('MMM dd yyyy, EEEE').format(now);
  }


  /// Load history
  Future<void> loadAttendance() async {
    isLoading.value = true;

    final results = await _locationService.fetchAttendanceHistory();
    history.assignAll(results);

    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    todayRecord =
        results.firstWhereOrNull((e) => e.date == today);

    isCheckedIn.value =
        todayRecord?.checkIn != null &&
            todayRecord?.checkOut == null;

    isLoading.value = false;
  }

  /// Timer update
  void updateLiveHours() {
    if (isCheckedIn.value && todayRecord?.checkIn != null) {
      final checkInDate =
      DateTime.parse("${todayRecord!.date} ${todayRecord!.checkIn}");
      liveWorkingHours.value =
          DateTime.now().difference(checkInDate);
    }
  }

  /// Check In / Out
  Future<void> toggleCheckInOut({ Map<String, String>?  checkOutInfo}) async {
    try {
      isLoading.value = true;

      if (!isCheckedIn.value) {
        final Position position =
        await _locationService.getCurrentLocation();

       final result= await _locationService.checkIn(
          lat: position.latitude,
          long: position.longitude,
        );
       if(result['success']==true){
         Fluttertoast.showToast(msg: "Checked in successfully",backgroundColor: Colors.green,textColor: Colors.white);
         isCheckedIn.value = true;
         await loadAttendance();
       }
       else{
         Fluttertoast.showToast(msg: "${result['data']['error']}",backgroundColor: Colors.red,textColor: Colors.white);
         return;
       }

      }
      else {
        await _locationService.checkOut(
          info: checkOutInfo

        );
        loadAttendance();
        Fluttertoast.showToast(msg: "Checked out successfully",backgroundColor: Colors.green,textColor: Colors.white);
      }

    } catch (e) {
      Fluttertoast.showToast(msg: e.toString(),backgroundColor: Colors.red,textColor: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

}