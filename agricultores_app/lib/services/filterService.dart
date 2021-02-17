import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/models/myOrderModel.dart';
import 'dart:convert';

class FilterService {

  static filter(int supplyID, int departmentID, int regionID, String minPrice, String maxPrice, String minHarvestDate, String maxHarvestDate, String role) async {
    String suffix = 'api/filter/';

    role == 'co' ? suffix += 'orders/?' : suffix += 'pubs/?';

    Map<String, String> queryParams = {};

    if (supplyID != null) queryParams['supply'] = supplyID.toString();
    if (departmentID != null) queryParams['department'] = supplyID.toString();
    if (regionID != 0 && regionID != null) queryParams['region'] = regionID.toString();
    if (minPrice != null && minPrice != "") queryParams['minPrice'] = minPrice;
    if (maxPrice != null && maxPrice != "") queryParams['maxPrice'] = maxPrice;
    if (minHarvestDate != null && minHarvestDate != "") queryParams['minHarvestDate'] = minHarvestDate;
    if (maxHarvestDate != null && maxHarvestDate != "") queryParams['maxHarvestDate'] = maxHarvestDate;

    String queryString = Uri(queryParameters: queryParams).query;

    suffix += queryString;

    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + suffix,
    );

    if (response.statusCode == 200) {
      var results;
      role == 'co' ? results = <MyOrder>[] : results = <MyPub>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var result in json) {
        var v = role == 'co' ? MyOrder.fromJson(result) : MyPub.fromJson(result);
        results.add(v);
      }
      return results;
    } else {
      throw Exception('Error al intentar aplicar el filtro');
    }
  }

}
