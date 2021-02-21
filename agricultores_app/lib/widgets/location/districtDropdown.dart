import 'package:agricultores_app/models/district.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/widgets/general/loading.dart';
import 'package:flutter/material.dart';

class DistrictDropdown extends StatefulWidget {

  const DistrictDropdown({
    Key key, 
    @required this.onChanged, 
    @required this.selectedRegion,
    @required this.selectedDistrict,
    @required this.ignoreCondition, 
    @required this.districts, 
    @required this.setDistricts, 
    @required this.districtsAreFetched
    }) : super(key: key);
  
  final onChanged;
  final selectedRegion;
  final selectedDistrict;
  final ignoreCondition;
  final List<District> districts;
  final setDistricts;
  final districtsAreFetched;

  @override
  _DistrictDropdownState createState() => _DistrictDropdownState();

}

class _DistrictDropdownState extends State<DistrictDropdown> {

  bool _fetchingDistricts = false;

  _getDistricts() async {
    setState(() {
      this._fetchingDistricts = true;
    });
    final response = await LocationService.getDistrictsByRegion(this.widget.selectedRegion); 
    this.widget.setDistricts(response);
    setState(() {
      this._fetchingDistricts = false;
    });
  }

  @override
  Widget build(BuildContext build) {
    if (this.widget.selectedRegion != null && this.widget.districtsAreFetched == false) {
      this._getDistricts();
    }
    return IgnorePointer(
      ignoring: this.widget.ignoreCondition,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.height * 0.8,
        child: this._fetchingDistricts
        ? CosechaLoading()
        : DropdownButtonFormField(
          validator: (value) => value == null ? 'Campo requerido' : null,
          isExpanded: true,
          hint: Text('Seleccione su departamento'),
          value: this.widget.selectedDistrict,
          onChanged: this.widget.onChanged,
          items: this.widget.districts.map((district) {
            return DropdownMenuItem(
              child: new Text(
                district.name,
                textAlign: TextAlign.center,
              ),
              value: district.id,
            );
          }).toList(),
        )
      )
    );
  }

}