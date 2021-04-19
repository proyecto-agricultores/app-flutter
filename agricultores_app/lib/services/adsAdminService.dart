import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/adsAdminModel.dart';

class AdsAdminService {
  static Future getAds() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'myAd/',
    );

    if (response.statusCode == 200) {
      var ads = <AdsAdmin>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var ad in json) {
        var v = AdsAdmin.fromJson(ad);
        ads.add(v);
      }
      return ads;
    } else {
      throw Exception('Error al intentar obtener los anuncios.');
    }
  }
}
