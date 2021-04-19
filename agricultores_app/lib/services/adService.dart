import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/adModel.dart';

class AdService {
  static Future getAdForIt(int id, String type) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'getAdForIt/?id=$id&type=$type',
    );

    if (response.statusCode == 200) {
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      return Ad.fromJson(json);
    } else {
      throw Exception('Error');
    }
  }
}
