import 'package:agricultores_app/interceptor/httpInterceptor.dart';
import 'package:agricultores_app/models/district.dart';
import 'dart:convert';

import 'package:agricultores_app/global/myHTTPConnection.dart';
import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/models/regionModel.dart';

class LocationService {
  static Future<List<Department>> getDepartments() async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'departments/',
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

  static Future<List<Region>> getRegionsByDepartment(int departmentId) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'api/filter/regions/?department=$departmentId',
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
      throw Exception(
          'Error al intentar obtener las regiones filtradas por el id de departamento $departmentId');
    }
  }

  static Future<List<District>> getDistrictsByRegion(int regionId) async {
    final response = await HTTPClient.getClient(WithToken.yes).get(
      MyHTTPConection.HTTP_URL + 'api/filter/districts/?region=$regionId',
    );

    if (response.statusCode == 200) {
      var districts = <District>[];
      var json = jsonDecode(utf8.decode(response.bodyBytes));
      for (var department in json) {
        var v = District.fromJson(department);
        districts.add(v);
      }
      return districts;
    } else {
      throw Exception(
          'Error al intentar obtener los distritios filtrados por el id de región $regionId');
    }
  }
}
