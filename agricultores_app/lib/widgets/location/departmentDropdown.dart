import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/general/loading.dart';

class DepartmentDropdown extends StatefulWidget {
  DepartmentDropdown({this.onChanged, this.selectedDepartment});

  final onChanged;
  final selectedDepartment;

  _DepartmentDropdownState createState() => _DepartmentDropdownState(onChanged: this.onChanged);
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {

  _DepartmentDropdownState({this.onChanged});

  List<Department> _departments;
  bool _fetchingDepartments = true;
  int selectedDepartment;
  final onChanged;

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
    return this._fetchingDepartments
      ? CosechaLoading()
      : Container(
      height: MediaQuery.of(context).size.height * 0.07,
      width: MediaQuery.of(context).size.width * 0.8,
      child: DropdownButton(
        isExpanded: true,
        hint: Text('Seleccione su departamento'),
        value: this.selectedDepartment,
        onChanged: (newValue) {
          this.onChanged(newValue);
          setState(() {
            this.selectedDepartment = newValue;
          });
        },
        items: this._departments.map((department) {
          return DropdownMenuItem(
            child: new Text(
              department.name,
              textAlign: TextAlign.center,
            ),
            value: department.id,
          );
        }).toList(),
      ),
    );
  }
  
}
