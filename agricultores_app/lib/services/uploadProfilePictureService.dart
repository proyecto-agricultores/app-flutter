import 'dart:io';

import 'package:agricultores_app/services/token.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

import 'package:agricultores_app/global/myHTTPConnection.dart';

class UploadProfilePictureService {
  static Future uploadProfilePicture(String filename) async {
    final accessToken = await Token.getToken(TokenType.access);
    Map<String, String> headers = {
      'Authorization': 'Bearer ' + accessToken,
    };

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(MyHTTPConection.HTTP_URL + 'uploadProfilePicture/'),
    );
    request.headers.addAll(headers);

    final extension = p.extension(File(filename).path);

    request.files.add(
      http.MultipartFile(
        'file',
        File(filename).readAsBytes().asStream(),
        File(filename).lengthSync(),
        filename: filename.split("/").last,
        contentType: MediaType('image', extension),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      return "OK";
    } else if (response.statusCode == 413) {
      return Exception('El archivo es muy grande');
    } else {
      throw Exception('Error.');
    }
  }
}
