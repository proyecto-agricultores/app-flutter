import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/widgets/location/locationDropdown.dart';
import 'package:flutter/material.dart';

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
    return LocationDropdown(
      ignoreCondition: this.widget.ignoreCondition,
      isLoading: this._fetchingRegions,
      selectedLocation: this.widget.selectedRegion,
      onChanged: this.widget.onChanged,
      listItems: this.widget.regions,
    );
  }
  
}
