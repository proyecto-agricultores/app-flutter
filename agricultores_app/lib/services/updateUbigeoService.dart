import 'dart:convert';
import 'package:agricultores_app/services/token.dart';
import 'package:http/http.dart' as http;

import 'package:agricultores_app/global/myHTTPConnection.dart';

class UpdateUbigeoService {
  static Future updateUbigeo(String districtId, double lat, double lon) async {
    String accessToken = await Token.getToken(TokenType.access);

    final response = await http.put(
      MyHTTPConection.HTTP_URL + 'updateUbigeo/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + accessToken
      },
      body: jsonEncode({
        "district": districtId,
        "lat": lat,
        "lon": lon,
      }),
    );

    if (response.statusCode == 200) {
      return 'OK!';
    } else {
      throw Exception('Error al momento de enviar el district.');
    }
  }
}
