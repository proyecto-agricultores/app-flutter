import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'token.dart';

class RegisterService {
  static Future createUser (
    String firstName,
    String lastName,
    String telephone,
    String dniOrRuc,
    String password,
    bool usingRuc
  ) async {
    String token = await Token.getToken(TokenType.access);

    final response = await http.post(
      MyHTTPConection.HTTP_URL + 'users/',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": telephone,
        (usingRuc ? "DNI" : "RUC"): dniOrRuc,
        "password": password,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Error al momento de realizar el registro');
    }
  }
}