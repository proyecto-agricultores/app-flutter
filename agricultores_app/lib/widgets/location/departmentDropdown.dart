import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/general/loading.dart';

class DepartmentDropdown extends StatefulWidget {
  DepartmentDropdown({this.onChanged, this.selectedDepartment});

  final onChanged;
  final selectedDepartment;

  _DepartmentDropdownState createState() => _DepartmentDropdownState();
}

class _DepartmentDropdownState extends State<DepartmentDropdown> {

  List<Department> _departments;
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
    return Container(
      height: MediaQuery.of(context).size.height * 0.11,
      width: MediaQuery.of(context).size.width * 0.8,
      child: this._fetchingDepartments 
      ? CosechaLoading()
      : DropdownButtonFormField(
        validator: (value) => value == null ? 'Campo requerido' : null,
        isExpanded: true,
        hint: Text('Seleccione su departamento'),
        value: this.widget.selectedDepartment,
        onChanged: this.widget.onChanged,
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
