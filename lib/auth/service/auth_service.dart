import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:nexuscrm/models/user_model.dart';

class AuthService extends GetxService{

  Future<UserModel?> loginApi(String email ,String password) async {
    final String csrfToken = "9O3Cjowk8MUDcZttRkeCTzpWYi0cdrdY";

    try {
      final response =await
      http.post(
          Uri.parse("https://crm.sudotechlabs.com/accounts/apilogin/"),
          headers: {
            'Content-Type': "application/json",
            'X-CSRFToken': csrfToken
          },
          body: jsonEncode({
            'username': email,
            'password': password,
          }
          )

      );
      print(response.statusCode);
      if (response.statusCode != 200) {
        print('API error response: ${response.body}');
      }
      if(response.statusCode==200){
        final body= jsonDecode(response.body);
        print(body);
        if(body['status']==true && body['data']!=null){
          final data=body['data'];
          final user = UserModel.fromJson(data);
          return user;

        }
        return null ;
      }
    }catch(error){
      print('Login error: $error');
      return null;
    }
  }
}