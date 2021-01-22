import 'package:http/http.dart' as http;
import 'token.dart';
import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/models/regionModel.dart';

class LocationService {
  static Future<List<Department> > getDepartments() async {
    final accessToken = await Token.getToken(TokenType.access);

    final response = await http.get(
      MyHTTPConection.HTTP_URL + 'departments/',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + accessToken,
      },
    );

    if (response.statusCode == 200) {
      var departments = <Department>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var department in json) {
        var v = Department.fromJson(department);
        departments.add(v);
      }
      return departments;
    } else {
      throw Exception('Error al intentar obtener los departamentos');
    }
  }

  static Future<List<Region> > getRegionsByDepartment(int departmentId) async {
    final accessToken = await Token.getToken(TokenType.access);

    final response = await http.get(
      MyHTTPConection.HTTP_URL + 'api/filter/regions/?department=$departmentId',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ' + accessToken,
      },
    );

    if (response.statusCode == 200) {
      var regions = <Region>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var department in json) {
        var v = Region.fromJson(department);
        regions.add(v);
      }
      return regions;
    } else {
      throw Exception('Error al intentar obtener las regiones filtradas por el id de departamento $departmentId');
    }
  }
}
