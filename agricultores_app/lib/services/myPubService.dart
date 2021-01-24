import 'dart:convert';

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/myPubModel.dart';

import 'package:agricultores_app/global/myHTTPConnection.dart';

class MyPubService {
  static Future getPubinUser() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myPub/',
    );

    if (response.statusCode == 200) {
      var list = <MyPub>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var element in json) {
        var v = MyPub.fromJson(element);
        list.add(v);
      }
      return list;
    } else {
      throw Exception('Error al recuperar la información del usuario.');
    }
  }
}
