import 'package:flutter/material.dart';

class UnitDropdown extends StatelessWidget {
  const UnitDropdown({this.initialUnit, this.updateUnit, this.items});
  
  final String initialUnit;
  final updateUnit;
  final items;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: this.initialUnit,
      icon: Icon(Icons.arrow_downward),
      onChanged: (String newValue) {
        updateUnit(newValue);
      },
      items: items.map<DropdownMenuItem<String>>(
          (priceUnit) {
        return DropdownMenuItem<String>(
          child: new Text(
            priceUnit.fullName,
            textAlign: TextAlign.center,
          ),
          value: priceUnit.abbreviation,
        );
      }).toList(),
    );
  }
}