import 'dart:convert';

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class CodeRegisterService {
  static Future generateCode() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'phoneVerification/',
    );

    if (response.statusCode != 200) {
      throw Exception('Error al momento de generar el código de registro');
    }
  }

  static Future sendCode(String code) async {
    final response = await HTTPClient.getClient(WithToken.yes).post(
      MyHTTPConection.HTTP_URL + 'phoneVerification/',
      body: jsonEncode(
        {"code": code},
      ),
    );

    if (response.body == "\"approved\"") {
      return 'ok';
    } else if (response.body == "\"pending\"") {
      return 'incorrect-code';
    } else {
      throw Exception("Error al mandar el código de Twilio");
    }
  }
}
