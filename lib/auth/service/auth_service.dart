import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nexuscrm/models/user_model.dart';

class AuthService extends GetxService {

  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("http://18.138.124.3/accounts/apilogin/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true && body['data'] != null) {
          return UserModel.fromJson(body['data']);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}
