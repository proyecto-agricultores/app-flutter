import 'dart:convert';
import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/global/myHTTPConnection.dart';

class UpdateUbigeoService {
  static Future updateUbigeo(String districtId, double lat, double lon) async {
    final response = await HTTPClient.getClient(WithToken.yes).put(
      MyHTTPConection.HTTP_URL + 'updateUbigeo/',
      body: jsonEncode(
        {
          "district": districtId,
          "lat": lat,
          "lon": lon,
        },
      ),
    );

    if (response.statusCode == 200) {
      return 'OK!';
    } else {
      throw Exception('Error al momento de enviar el district.');
    }
  }
}
