import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/leave_model.dart';

class LeaveService extends GetxService{
  final storage=GetStorage();
  late final token=storage.read('token');

  Future<List<LeaveModel>> getLeaveData() async {
    try {
      final response = await http.get(
        Uri.parse('http://18.138.124.3/accounts/leaves/leave_history/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json'
        },
      );

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Ensure "leaves" exists
        if (data['leaves'] != null) {
          final List<dynamic> leaves = data['leaves'];
          return leaves.map((e) => LeaveModel.fromJson(e)).toList();
        } else {
          throw Exception("Key 'leaves' not found");
        }
      } else {
        throw Exception('Failed to load leave history');
      }
    } catch (e) {
      print('error in leave service: $e');
      return [];
    }
  }

  Future<dynamic> addLeave(String leaveType, String startDate, String endDate, String reason) async {
    try{
      final response = await http.post(
          Uri.parse('http://18.138.124.3/accounts/leave/request/'),
          body:jsonEncode({
            "leave_type": leaveType,
            "start_date": startDate,
            "end_date": endDate,
            "reason": reason
          }),
          headers:{
            'Authorization':'Token $token',
            'Content-Type':'application/json'
          });

      print(response.body);
      var data=jsonDecode(response.body);
      if(response.statusCode==200||response.statusCode==201){
        return true;
      }else{
        return false;
      }
    }catch(e){
      print('error in add leave service: $e');
      return false;
    }
    }

  }

