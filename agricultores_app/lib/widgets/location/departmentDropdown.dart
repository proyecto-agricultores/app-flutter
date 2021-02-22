import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/widgets/location/locationDropdown.dart';
import 'package:flutter/material.dart';

class DepartmentDropdown extends StatefulWidget {
  DepartmentDropdown({this.onChanged, this.selectedDepartment});

  final onChanged;
  final selectedDepartment;

  _DepartmentDropdownState createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {

  List<Department> _departments = [Department(id: 0, name: '')];
  bool _fetchingDepartments = true;

  @override
  initState() {
    super.initState();
    this._getDepartments();
  }

  _getDepartments() async {
    final response = await LocationService.getDepartments();
    setState(() {
      this._departments = response;
      this._fetchingDepartments = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LocationDropdown(
      ignoreCondition: false,
      isLoading: this._fetchingDepartments,
      selectedLocation: this.widget.selectedDepartment,
      onChanged: this.widget.onChanged,
      listItems: this._departments,
      text: 'Seleccione su departamento',
    );
  }
  
}
