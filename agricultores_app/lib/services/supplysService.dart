import 'dart:convert';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/models/supplyModel.dart';

class SupplyService {
  static Future getSupplys() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'supplys/',
    );
    if (response.statusCode == 200) {
      var districts = <Supply>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var supply in json) {
        var v = Supply.fromJson(supply);
        districts.add(v);
      }
      return districts;
    } else {
      throw Exception('Error al recuperar supplys.');
    }
  }
}
