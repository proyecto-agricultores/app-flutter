import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/widgets/location/locationDropdown.dart';
import 'package:agricultores_app/widgets/location/regionAndDistrictTemplateDropdown.dart';
import 'package:flutter/material.dart';

class RegionDropdown extends StatelessWidget {
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
    
  Widget build(BuildContext build) {
    return RegionAndDistrictTemplateDropdown(
      onChanged: this.onChanged,
      selectedParentLocation: this.selectedDepartment,
      selectedLocation: this.selectedRegion,
      ignoreCondition: this.ignoreCondition,
      listItems: this.regions,
      setData: this.setRegions,
      listItemsAreFetched: this.regionsAreFetched,
      dataGetter: LocationService.getRegionsByDepartment,
      text: 'Seleccione su región',
    );
  }
}
