import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/SupplyDaysForHarvestModel.dart';

class SupplyDaysForHarvestService {

  static Future<SupplyDaysForHarvest> getDays(int id, String uri) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + "$uri/$id/"
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return SupplyDaysForHarvest.fromJson(json);
    } else {
      throw Exception("Error al intentar obtener los supplies de $uri $id");
    }    
  }
  
  static Future<SupplyDaysForHarvest> getDaysForOrder(int id) async {
    return getDays(id, "orderSupply");
  }

  static Future<SupplyDaysForHarvest> getDaysForPublication(int id) async {
    return getDays(id, "publicationSupply");
  }
}