import 'package:flutter/material.dart';

import 'locationDropdown.dart';

class RegionAndDistrictTemplateDropdown extends StatefulWidget {

  const RegionAndDistrictTemplateDropdown({
    Key key, 
    @required this.onChanged, 
    @required this.selectedParentLocation,
    @required this.selectedLocation,
    @required this.ignoreCondition, 
    @required this.listItems, 
    @required this.setData, 
    @required this.listItemsAreFetched,
    @required this.dataGetter,
    @required this.text,
  }) : super(key: key);
  
  final onChanged;
  final selectedParentLocation;
  final selectedLocation;
  final ignoreCondition;
  final List<dynamic> listItems;
  final setData;
  final listItemsAreFetched;
  final dataGetter;
  final text;

  @override
  _RegionAndDistrictTemplateDropdownState createState() => _RegionAndDistrictTemplateDropdownState();

}

class _RegionAndDistrictTemplateDropdownState extends State<RegionAndDistrictTemplateDropdown> {

  bool _fetchingData = false;

  _getData() async {
    setState(() {
      this._fetchingData = true;
    });
    final response = await this.widget.dataGetter(this.widget.selectedParentLocation); 
    this.widget.setData(response);
    setState(() {
      this._fetchingData = false;
    });
  }

  @override
  Widget build(BuildContext build) {
    if (this.widget.selectedParentLocation != null && this.widget.listItemsAreFetched == false) {
      this._getData();
    }
    return LocationDropdown(
      ignoreCondition: this.widget.ignoreCondition,
      isLoading: this._fetchingData,
      selectedLocation: this.widget.selectedLocation,
      onChanged: this.widget.onChanged,
      listItems: this.widget.listItems,
      text: this.widget.text,
    );
  }

}