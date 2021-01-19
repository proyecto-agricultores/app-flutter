import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:agricultores_app/global/myHTTPConnection.dart';

class RegisterService {
  static Future createUser (
    String firstName,
    String lastName,
    String telephone,
    String dniOrRuc,
    String password,
    bool usingRuc
  ) async {
    final response = await http.post(
      MyHTTPConection.HTTP_URL + 'users/',
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": telephone,
        (usingRuc ? "RUC" : "DNI"): dniOrRuc,
        (usingRuc ? "DNI" : "RUC"): "",
        "password": password,
      }),
    );

    if (response.body == "{\"phone_number\":[\"user with this phone number already exists.\"]}") {
      return 'phone already in use';
    } else if (response.statusCode != 201) {
      throw Exception('Error al momento de realizar el registro');
    } else if (response.statusCode == 201) {
      return 'ok';
    }
  }
}