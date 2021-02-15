import 'dart:convert';
import 'dart:io';

import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/models/myPubModel.dart';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/services/token.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class UserFilterService {
  static Future getAgricultores() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'api/filter/agricultores/',
    );

    if (response.statusCode == 200) {
      var list = <User>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var element in json) {
        var v = User.fromJson(element);
        list.add(v);
      }
      return list;
    } else {
      throw Exception('Error al recuperar la información de agricultores.');
    }
  }

  static Future getCompradores() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'api/filter/compradores/',
    );

    if (response.statusCode == 200) {
      var list = <User>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var element in json) {
        var v = User.fromJson(element);
        list.add(v);
      }
      return list;
    } else {
      throw Exception('Error al recuperar la información de compradores.');
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

  static Future update(MyPub myPub) async {
    final response = await HTTPClient.getClient(WithToken.yes).put(
      MyHTTPConection.HTTP_URL + 'myPub/' + myPub.id.toString() + '/',
      body: jsonEncode(
        {
          "weight_unit": myPub.weightUnit,
          "unit_price": myPub.unitPrice,
          "area_unit": myPub.areaUnit,
          "area": myPub.area,
          "harvest_date": myPub.harvestDate.toUtc().toString(),
          "sowing_date": myPub.sowingDate.toUtc().toString(),
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

  static Future create(int supplyId, MyPub myPub) async {
    final response = await HTTPClient.getClient(WithToken.yes).post(
      MyHTTPConection.HTTP_URL + 'myPub/',
      body: jsonEncode(
        {
          "supplies": supplyId,
          "weight_unit": myPub.weightUnit,
          "unit_price": myPub.unitPrice,
          "area_unit": myPub.areaUnit,
          "area": myPub.area,
          "harvest_date": myPub.harvestDate.toUtc().toString(),
          "sowing_date": myPub.sowingDate.toUtc().toString(),
          "picture_URLs": [],
        },
      ),
    );

    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyPub.fromJson(json);
    } else {
      throw Exception('Error al crear.');
    }
  }

  static Future delete(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).delete(
      MyHTTPConection.HTTP_URL + 'myPub/' + id.toString() + '/',
    );
    if (response.statusCode == 204) {
      return 'OK';
    } else {
      throw Exception('Error al eliminar.');
    }
  }

  static Future appendPubPicture(int id, String filename) async {
    final accessToken = await Token.getToken(TokenType.access);
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + accessToken,
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
          MyHTTPConection.HTTP_URL + 'uploadPubPicture/' + id.toString() + '/'),
    );
    request.headers.addAll(headers);

    request.files.add(
      http.MultipartFile(
        'file',
        File(filename).readAsBytes().asStream(),
        File(filename).lengthSync(),
        filename: filename.split("/").last,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      return "OK";
    } else if (response.statusCode == 413) {
      return Exception('El archivo es muy grande');
    } else {
      throw Exception('Error.');
    }
  }
}
