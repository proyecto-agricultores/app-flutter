import 'dart:convert';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class RegisterService {
  static Future createUser(String firstName, String lastName, String telephone,
      String dniOrRuc, String password, bool usingRuc) async {
    final response = await HTTPClient.getClient(WithToken.no).post(
      MyHTTPConection.HTTP_URL + 'users/',
      body: jsonEncode(
        {
          "first_name": firstName,
          "last_name": lastName,
          "phone_number": telephone,
          (usingRuc ? "RUC" : "DNI"): dniOrRuc,
          (usingRuc ? "DNI" : "RUC"): "",
          "password": password,
        },
      ),
    );

    if (response.body ==
        "{\"phone_number\":[\"Usuario with this phone number already exists.\"]}") {
      return 'phone already in use';
    } else if (response.statusCode != 201) {
      return ['error', response.body];
    } else if (response.statusCode == 201) {
      return 'ok';
    }
  }
}
