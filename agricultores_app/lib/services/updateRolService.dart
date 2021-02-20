import 'dart:convert';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class UpdateRolService {
  static Future updateRol(String role) async {
    final response = await HTTPClient.getClient(WithToken.yes).put(
      MyHTTPConection.HTTP_URL + 'updateRol/',
      body: jsonEncode(
        {
          "role": role,
        },
      ),
    );

    if (response.statusCode == 200) {
      return 'OK!';
    } else {
      throw Exception('Error al momento de enviar el rol.');
    }
  }
}
