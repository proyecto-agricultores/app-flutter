import 'dart:convert';

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/myUserModel.dart';

import 'package:agricultores_app/global/myHTTPConnection.dart';

class MyProfileService {
  static Future getLoggedinUser() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myInfo/',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyUser.fromJson(json[0]);
    } else {
      throw Exception('Error al recuperar la información del usuario.');
    }
  }
}
