import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../models/lead_response.dart';

class AutoCallService extends GetxService {

  Future<LeadsResponse?> fetchDashboard() async {
    const url = 'http://18.138.124.3/accounts/api/staff/dashboard';
    final storage = GetStorage();
    final token = storage.read('token');

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return LeadsResponse.fromJson(jsonResponse);
      } else {
        print('API Error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('API Exception: $e');
      return null;
    }
  }


  Future<bool> updateLeadStatus({
  required int leadId,
  required String status,
  }) async {
  final token = GetStorage().read('token');

  final url =
  'http://18.138.124.3/accounts/api/staff/update-lead/$leadId/';

  try {
  final response = await http.post(
  Uri.parse(url),
  headers: {
  'Authorization': 'Token $token',
  'Content-Type': 'application/json',
  },
  body: jsonEncode({
  "status": status,
  }),
  );

  if (response.statusCode == 200 || response.statusCode == 202) {
  print("✅ Lead updated successfully");
  return true;
  } else {
  print("Update failed: ${response.body}");
  return false;
  }
  } catch (e) {
  print(" API Exception: $e");
  return false;
  }
  }
  }


