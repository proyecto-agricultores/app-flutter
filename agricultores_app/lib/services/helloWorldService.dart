import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:http/http.dart' as http;
import 'package:agricultores_app/services/token.dart';

class HelloWorldService {
  static Future<String> getHelloWorld() async {
    String accessToken = await Token.getToken(TokenType.access);

    final response = await http.get(
      MyHTTPConection.HTTP_URL + 'hello/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + accessToken,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Error hello world.');
    }
  }
}
