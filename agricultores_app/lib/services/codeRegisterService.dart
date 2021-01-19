import 'dart:convert';

import 'package:http/http.dart' as http;

import 'token.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class CodeRegisterService {
  static Future generateCode() async {
    final accessToken = await Token.getToken(TokenType.access);

    final response = await http.get(
        MyHTTPConection.HTTP_URL + 'phoneVerification/',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer ' + accessToken,
        });

    if (response.statusCode != 200) {
      throw Exception('Error al momento de generar el código de registro');
    }
  }

  static Future sendCode(String code) async {
    final accessToken = await Token.getToken(TokenType.access);

    final response =
        await http.post(MyHTTPConection.HTTP_URL + 'phoneVerification/',
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'Authorization': 'Bearer ' + accessToken,
            },
            body: jsonEncode({"code": code}));

    if (response.body == "\"approved\"") {
      return 'ok';
    } else if (response.body == "\"pending\"") {
      return 'incorrect-code';
    } else {
      throw Exception("Error al mandar el código de Twilio");
    }
  }
}
