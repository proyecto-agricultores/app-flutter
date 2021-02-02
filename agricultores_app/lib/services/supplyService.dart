import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/supplyModel.dart';

class SupplyService {
  static Future<List<Supply> > getSupplies() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'supplys/',
    );

    if (response.statusCode == 200) {
      var supplies = <Supply>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var supply in json) {
        var v = Supply.fromJson(supply);
        supplies.add(v);
      }
      return supplies;
    } else {
      throw Exception('Error al intentar obtener los insumos');
    }
  }
}