import 'package:http/http.dart' as http;
import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/models/authModel.dart';

import 'dart:convert';

// enum AuthenticationStatus { authorized, denied, unknown }

class AuthenticateService {
  static Future<AuthenticateUser> authenticate(
      String phoneNumber, String password) async {
    final response = await http.post(
      MyHTTPConection.HTTP_URL + 'api/token/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': phoneNumber,
        'password': password,
      }),
    );
    if (response.statusCode == 200) {
      return AuthenticateUser.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('/api/token/ error. Unauthorized');
    }
  }

  static Future<AuthenticateUser> refresh(String refreshToken) async {
    final response = await http.post(
      MyHTTPConection.HTTP_URL + 'api/token/refresh/',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String> {
        'refresh': refreshToken,
      })
    );
    if (response.statusCode == 200) {
      return AuthenticateUser.fromJsonRefresh(jsonDecode(response.body));
    } else {
      throw Exception('/api/token/refresh/ error. Unauthorized');
    }
  }
}
