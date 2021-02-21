import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/general/loading.dart';

class RegionDropdown extends StatefulWidget {
  RegionDropdown({
    @required this.onChanged,
    @required this.selectedDepartment,
    @required this.selectedRegion, 
    @required this.ignoreCondition, 
    @required this.regions, 
    @required this.setRegions,
    @required this.regionsAreFetched,
  });

  final onChanged;
  final selectedDepartment;
  final selectedRegion;
  final ignoreCondition;
  final List<Region> regions;
  final setRegions;
  final regionsAreFetched;

  _RegionDropdownState createState() => _RegionDropdownState();
}

class _RegionDropdownState extends State<RegionDropdown> {

  bool _fetchingRegions = false;

  _getRegions() async {
    setState(() {
      this._fetchingRegions = true;
    });
    final response = await LocationService.getRegionsByDepartment(this.widget.selectedDepartment);
    this.widget.setRegions(response);
    setState(() {
      this._fetchingRegions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.widget.selectedDepartment != null && this.widget.regionsAreFetched == false) {
      this._getRegions();
    }
    return IgnorePointer(
      ignoring: this.widget.ignoreCondition,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width * 0.8,
        child: this._fetchingRegions 
        ? CosechaLoading()
        : DropdownButtonFormField(
          validator: (value) => value == null ? 'Campo requerido' : null,
          isExpanded: true,
          hint: Text('Seleccione su región'),
          value: this.widget.selectedRegion,
          onChanged: this.widget.onChanged,
          items: this.widget.regions.map((region) {
            return DropdownMenuItem(
              child: new Text(
                region.name,
                textAlign: TextAlign.center,
              ),
              value: region.id,
            );
          }).toList(),
        ),
      )
    );
  }
  
}
