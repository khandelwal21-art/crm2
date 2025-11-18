import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class AutoCallService extends GetxService{
  List<Map<String,dynamic>> numbers=[];

  Future<List<Map<String, dynamic>>> fetchNumbersFromApi() async {
    const url = 'https://crm.sudotechlabs.com/accounts/api/admin-leads/total_upload_lead_tag/';
    final sessionId = 'k7fuutc4l91rs1xpwyppif5k79ywpdjo';
    try {
      final response = await http.get(Uri.parse(url),
        headers: {
          'Cookie': 'sessionid=$sessionId',
          'Content-Type': 'application/json',
        },);
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> results = jsonResponse['results'];

        // Map results to your list of maps with keys 'number', 'name', and default 'isInterested'
        final List<Map<String, dynamic>> fetchedNumbers = results.map((item) {
          return {
            'number': item['call'],
            'name': item['name'],
            'isInterested': false, // Default false; you can update later
          };
        }).toList();
        return fetchedNumbers;
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }


}