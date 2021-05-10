import 'dart:async';
import "dart:convert";

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class ChangePasswordService {

  static Future generateCode(String phoneNumber) async {
    var queryParameters = {
      "phone_number": phoneNumber,
    };
    String uri = "${MyHTTPConection.HTTP_URL}changePassword?";
    uri += Uri(queryParameters: queryParameters).query;

    String encodedPhoneNumber = "${Uri.encodeComponent("+")}${phoneNumber.substring(1)}";

    final response = await HTTPClient.getClient(WithToken.no).get(
      // uri
      "https://cosecha-api.herokuapp.com/changePassword?phone_number=${encodedPhoneNumber}"
    );

    print(response.statusCode);
    print(response.toString());
    print(response.body);
    print(response.request.url);
    print(phoneNumber);
    print(encodedPhoneNumber);

    if (response.statusCode != 200) {
      throw Exception('Error al momento de generar el código de registro');
    }
  }

  static Future changePassword(String code, String newPassword, String phoneNumber) async {
    final response = await HTTPClient.getClient(WithToken.no).post(
      MyHTTPConection.HTTP_URL + 'changePassword/',
      body: jsonEncode(
        {
          "code": code,
          "phone_number": phoneNumber,
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
