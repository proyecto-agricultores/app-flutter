import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';

class CreateOrderService {
  static Future createUser(int supplyId, int quantity, double price, DateTime sowingDate, DateTime harvestDate) async {
    final response = await HTTPClient.getClient(WithToken.yes).post(
      MyHTTPConection.HTTP_URL + 'order/',
      body: jsonEncode(
        {
          "unit": "Kg",
          "number": quantity,
          "unit_price": price,
          "desire_harvest_date": harvestDate,
          "desire_sowing_date": sowingDate,
          "suppiles": supplyId
        }
      ),
    );
    if (response.statusCode == 201) {
      return 'ok';
    } else {
      throw Exception('Error al momento de crear una orden');
    }
  }
}