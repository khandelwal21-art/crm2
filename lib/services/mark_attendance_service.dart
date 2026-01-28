  import 'dart:convert';

  import 'package:geolocator/geolocator.dart';
  import 'package:get/get.dart';
  import 'package:get_storage/get_storage.dart';
  import 'package:http/http.dart' as http;
  import '../models/attendance_record.dart';

  class MarkAttendanceService  extends GetxService {
    final storage = GetStorage();
    late final token = storage.read('token');

    Future<Position> getCurrentLocation() async {
      bool serviceEnabled;
      LocationPermission permission;

      //check whether location services are enabled or not
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw Exception('Location services are disabled');
      }


      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Location permission denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Location permission permanently denied');
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    }

    Future<List<AttendanceRecord>> fetchAttendanceHistory() async {
      await Future.delayed(const Duration(seconds: 1));
      final token = storage.read('token'); // 👈 get token from local storage
      final url =
      Uri.parse('http://18.138.124.3/accounts/myattendance/');
      final response =
      await http.get(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Token $token'}
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        return data
            .map((e) => AttendanceRecord.fromJson(e))
            .toList(); // Convert JSON to list of dynamic objects
      } else {
        throw Exception('Failed to load attendance history');
      }
    }

    /// 🔹 CHECK IN API WITH AUTH TOKEN
    Future<Map<String,dynamic>> checkIn({
      required double lat,
      required double long, // 👈 pass token
    }) async {
      final url = Uri.parse('http://18.138.124.3/accounts/checkin/');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Token $token', // ✅ AUTH
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'latitude': lat,
          'longitude': long,
        }),
      );


      if (response.statusCode == 200 || response.statusCode == 201) {
        print("CHECK IN SUCCESS");
        return {'success':true,'message':'Check in successful','data':jsonDecode(response.body)};
      }
      else {
        print("CHECK IN FAILED");
        print(response.body);
        return {'success':false,'message':response,'data':jsonDecode(response.body)};
      }
    }


    /// 🔹 CHECK OUT API WITH AUTH TOKEN
    Future<String> checkOut({
      Map<String, String>? info,
    }) async {
      final url = Uri.parse('http://18.138.124.3/accounts/checkout/');

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'project': info?['projectName'],
          'work': info?['workDescription'],
          'time_taken': info?['taskTime'],
          'progress': info?['workProgress'],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("checked out");
        return "Checked out successfully";
      } else {
        // 🔥 PRINT ERROR DETAILS HERE
        print("CHECK OUT FAILED");
        print("Status Code: ${response.statusCode}");
        print("Response Body: ${response.body}");

        throw Exception(
          "Check-out failed (${response.statusCode}): ${response.body}",
        );
      }
    }
  }


