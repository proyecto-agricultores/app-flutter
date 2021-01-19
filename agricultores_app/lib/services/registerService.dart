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
    bool usingDni
  ) async {
    String token = await Token.getToken(TokenType.access);

    final response = await http.post(
      MyHTTPConection.HTTP_URL + 'users/',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + token,
      },
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": telephone,
        (usingDni ? "DNI" : "RUC"): dniOrRuc,
        "password": password,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al momento de realizar el registro');
    }
  }
}