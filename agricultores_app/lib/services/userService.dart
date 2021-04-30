import 'dart:convert';

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class UserService {
  static Future getUser(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'users/' + id.toString() + '/',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return User.fromJson(json);
    } else {
      throw Exception('Error al recuperar la información del usuario.');
    }
  }
}
