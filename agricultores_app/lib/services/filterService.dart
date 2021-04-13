import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/models/myOrderModel.dart';
import 'package:agricultores_app/models/myUserModel.dart';
import 'dart:convert';

class FilterService {

  static filterPubsAndOrders(int supplyID, int departmentID, int regionID, String minPrice, String maxPrice, String minHarvestDate, String maxHarvestDate, String role) async {
    String suffix = 'api/filter/';

    role == 'co' ? suffix += 'orders/?' : suffix += 'pubs/?';

    Map<String, String> queryParams = {};

    if (supplyID != null) queryParams['supply'] = supplyID.toString();
    if (departmentID != null) queryParams['department'] = departmentID.toString();
    if (regionID != 0 && regionID != null) queryParams['region'] = regionID.toString();
    if (minPrice != null && minPrice != "") queryParams['min_price'] = minPrice;
    if (maxPrice != null && maxPrice != "") queryParams['max_price'] = maxPrice;
    if (minHarvestDate != null && minHarvestDate != "") queryParams['min_date'] = minHarvestDate;
    if (maxHarvestDate != null && maxHarvestDate != "") queryParams['max_date'] = maxHarvestDate;

    String queryString = Uri(queryParameters: queryParams).query;

    suffix += queryString;

    print(suffix);

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
      throw Exception('Error al intentar aplicar el filtro de ' + role == 'co' ? 'órdenes' : 'publicaciones');
    }
  }

  static filterFarmersAndClients(int supplyID, int departmentID, int regionID, String role) async {
    String suffix = 'api/filter/';

    role == 'co' ? suffix += 'compradores/?' : suffix += 'agricultores/?';

    Map<String, String> queryParams = {};

    if (supplyID != null) queryParams['supply'] = supplyID.toString();
    if (departmentID != null) queryParams['department'] = departmentID.toString();
    if (regionID != 0 && regionID != null) queryParams['region'] = regionID.toString();

    String queryString = Uri(queryParameters: queryParams).query;

    suffix += queryString;

    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + suffix,
    );

    if (response.statusCode == 200) {
      var results = <MyUser>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var result in json) {
        var v = MyUser.fromJson(result);
        results.add(v);
      }
      return results;
    } else {
      throw Exception('Error al intentar aplicar el filtro de ' + role == 'co' ? 'compradores' : 'agricultores');
    }
  }

}
