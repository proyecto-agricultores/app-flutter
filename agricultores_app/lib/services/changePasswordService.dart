import 'dart:async';
import "dart:convert";

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class ChangePasswordService {

  static Future generateCode(String phoneNumber) async {
    final response = await HTTPClient.getClient(WithToken.no).get(
      "${MyHTTPConection.HTTP_URL}changePassword?phone_number=${phoneNumber.substring(1)}"
    );

    if (response.statusCode == 429) {
      throw Exception("El servidor no puede manejar más pedidos el día de hoy. Por favor, intente en 24 horas.");
    } else if (response.statusCode != 200) {
      throw Exception('Error al momento de generar el código de registro');
    }
  }

  static Future changePassword(String code, String newPassword, String phoneNumber) async {
    final response = await HTTPClient.getClient(WithToken.no).post(
      MyHTTPConection.HTTP_URL + 'changePassword',
      body: jsonEncode(
        {
          "code": code,
          "phone_number": phoneNumber.substring(1),
          "new_password": newPassword,
        },
      ),
    );

    if (response.body == "\"approved\"") {
      return 'ok';
    } else if (response.body == "\"pending\"") {
      throw Exception("Código incorrecto");
    } else {
      throw Exception("Error al cambiar contraseña");
    }
  }
  
}
