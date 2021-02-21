import 'package:agricultores_app/models/district.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/widgets/location/regionAndDistrictTemplateDropdown.dart';
import 'package:flutter/material.dart';

class DistrictDropdown extends StatelessWidget {

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
  Widget build(BuildContext build) {
    return RegionAndDistrictTemplateDropdown(
      onChanged: this.onChanged,
      selectedParentLocation: this.selectedRegion,
      selectedLocation: this.selectedDistrict,
      ignoreCondition: this.ignoreCondition,
      listItems: this.districts,
      setData: this.setDistricts,
      listItemsAreFetched: this.districtsAreFetched,
      dataGetter: LocationService.getDistrictsByRegion,
      text: 'Seleccione su distrito',
    );
  }
}
