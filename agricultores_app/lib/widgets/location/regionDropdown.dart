import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/general/loading.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/services/locationService.dart';

class RegionDropdown extends StatefulWidget {

  RegionDropdown({this.onChanged});

  final onChanged;

  @override
  _RegionDropdownState createState() => _RegionDropdownState();

}

class _RegionDropdownState extends State<RegionDropdown> {

  _RegionDropdownState({this.onChanged, this.departmentIsSelected, this.selectedDepartment});

  final onChanged;
  final departmentIsSelected;
  final selectedDepartment;
  int _selectedRegion;
  List<Region> _regions = [Region(id: 0, name: '')];
  bool _fetchingRegions = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    this._getRegions();
  }

  void _getRegions() async {
    if (this.selectedDepartment != null) {
      final response = await LocationService.getRegionsByDepartment(this.selectedDepartment);
      setState(() {
        this._regions = response;
        this._fetchingRegions = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return this._fetchingRegions
      ? CosechaLoading()
      : IgnorePointer(
      ignoring: !departmentIsSelected,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.height * .8,
        child: DropdownButton(
          isExpanded: true,
          hint: Text('Seleccione su región'),
          value: _selectedRegion,
          onChanged: (newValue) {
            this.onChanged(newValue);
            setState(() {
              _selectedRegion = newValue;
            });
          },
          items: this._regions.map((region) {
            return DropdownMenuItem(
              child: new Text(
                region.name,
                textAlign: TextAlign.center,
              ),
              value: region.id,
            );
          }).toList(),
        )
      )
    );
  }

}
