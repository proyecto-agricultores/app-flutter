import 'dart:convert';
import 'dart:io';

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

  static Future getPubinUserById(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myPub/' + id.toString() + '/',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyPub.fromJson(json[0]);
    } else {
      throw Exception(
          'Error al recuperar la información en publicación por ID.');
    }
  }

  static Future update(
    int id,
    String pictureURL,
    String unit,
    int quantity,
    DateTime harvestDate,
    DateTime sowingDate,
    double unitPrice,
  ) async {
    final response = await HTTPClient.getClient(WithToken.yes).put(
      MyHTTPConection.HTTP_URL + 'myPub/' + id.toString() + '/',
      body: jsonEncode(
        {
          "unit": unit,
          "harvest_date": harvestDate.toUtc().toString(),
          "sowing_date": sowingDate.toUtc().toString(),
          "unit_price": unitPrice,
          "quantity": quantity,
        },
      ),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyPub.fromJson(json);
    } else {
      throw Exception('Error al editar.');
    }
  }

  static Future delete(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).delete(
      MyHTTPConection.HTTP_URL + 'myPub/' + id.toString() + '/',
    );
    if (response.statusCode == 200) {
      return 'OK';
    } else {
      throw Exception('Error al eliminar.');
    }
  }
}
