import 'dart:convert';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/myOrderModel.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class MyOrderService {
  static Future getOrdersFromUser() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myOrder/',
    );

    if (response.statusCode == 200) {
      var list = <MyOrder>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var element in json) {
        var v = MyOrder.fromJson(element);
        list.add(v);
      }
      return list;
    } else {
      throw Exception('Error al recuperar la orden del usuario.');
    }
  }

  static Future getFeaturedOrdersFromUser() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myFeaturedOrder/',
    );

    if (response.statusCode == 200) {
      var list = <MyOrder>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var element in json) {
        var v = MyOrder.fromJson(element);
        list.add(v);
      }
      return list;
    } else {
      throw Exception('Error al recuperar la orden del usuario.');
    }
  }

  static Future getOrderFromUserById(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myOrder/' + id.toString() + '/',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyOrder.fromJson(json[0]);
    } else {
      throw Exception(
          'Error al recuperar la información en publicación por ID.');
    }
  }

  static Future getOrderById(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'order/' + id.toString() + '/',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyOrder.fromJson(json);
    } else {
      throw Exception(
          'Error al recuperar la información en publicación por ID.');
    }
  }

  static Future update(MyOrder myOrder) async {
    final response = await HTTPClient.getClient(WithToken.yes).put(
      MyHTTPConection.HTTP_URL + 'myOrder/' + myOrder.id.toString() + '/',
      body: jsonEncode(
        {
          "weight_unit": myOrder.weightUnit,
          "unit_price": myOrder.unitPrice,
          "area_unit": myOrder.areaUnit,
          "area": myOrder.area,
          "desired_harvest_date": myOrder.harvestDate.toUtc().toString(),
          "desired_sowing_date": myOrder.sowingDate.toUtc().toString(),
        },
      ),
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyOrder.fromJson(json);
    } else {
      throw Exception('Error al editar.');
    }
  }

  static Future create(int supplyId, MyOrder myOrder) async {
    final response = await HTTPClient.getClient(WithToken.yes).post(
      MyHTTPConection.HTTP_URL + 'myOrder/',
      body: jsonEncode(
        {
          "supplies": supplyId,
          "weight_unit": myOrder.weightUnit,
          "unit_price": myOrder.unitPrice,
          "area_unit": myOrder.areaUnit,
          "area": myOrder.area,
          "desired_harvest_date": myOrder.harvestDate.toUtc().toString(),
          "desired_sowing_date": myOrder.sowingDate.toUtc().toString(),
        },
      ),
    );

    if (response.statusCode == 201) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return MyOrder.fromJson(json);
    } else {
      throw Exception('Error al crear.');
    }
  }

  static Future delete(int id) async {
    final response = await HTTPClient.getClient(WithToken.yes).delete(
      MyHTTPConection.HTTP_URL + 'myOrder/' + id.toString() + '/',
    );
    if (response.statusCode == 204) {
      return 'OK';
    } else {
      throw Exception('Error al eliminar.');
    }
  }
}
