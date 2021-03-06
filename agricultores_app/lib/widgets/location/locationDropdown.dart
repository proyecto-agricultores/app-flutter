import 'package:flutter/material.dart';

class LocationDropdown extends StatelessWidget {

  LocationDropdown({
    @required this.ignoreCondition,
    @required this.isLoading,
    @required this.selectedLocation,
    @required this.onChanged,
    @required this.listItems,
    @required this.text,
  });

  final bool ignoreCondition;
  final bool isLoading;
  final int selectedLocation;
  final onChanged;
  final List<dynamic> listItems;
  final String text;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: this.ignoreCondition || this.isLoading,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.11,
        width: MediaQuery.of(context).size.width * 0.8,
        child: DropdownButtonFormField(
          validator: (value) => value == null ? 'Campo requerido' : null,
          isExpanded: true,
          hint: Text(this.isLoading ? 'Cargando...' : this.text),
          value: this.selectedLocation,
          onChanged: this.onChanged,
          items: this.listItems.map<DropdownMenuItem<int>>((item) {
            return DropdownMenuItem(
              child: new Text(
                item.name,
                textAlign: TextAlign.center,
              ),
              value: item.id,
            );
          }).toList(),
        ),
      )
    );
  }

}