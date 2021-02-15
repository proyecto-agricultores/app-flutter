import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/general/loading.dart';

class CosechaLocationDropdown extends StatefulWidget {

  _CosechaLocationDropdownState createState() => _CosechaLocationDropdownState();

}

class _CosechaLocationDropdownState extends State<CosechaLocationDropdown> {

  _CosechaLocationDropdownState({this.onChanged, this.ignoring, this.options, this.fetchingData});

  final onChanged;
  final ignoring;
  final options;
  final fetchingData;

  int _selected;

  @override
  Widget build(BuildContext context) {
    return this.fetchingData
      ? CosechaLoading()
      : IgnorePointer(
      ignoring: this.ignoring,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.07,
        width: MediaQuery.of(context).size.height * .8,
        child: DropdownButton(
          isExpanded: true,
          hint: Text('Seleccione su región'),
          value: _selected,
          onChanged: (newValue) {
            this.onChanged(newValue);
            setState(() {
              _selected = newValue;
            });
          },
          items: this.options.map((selection) {
            return DropdownMenuItem(
              child: new Text(
                selection.name,
                textAlign: TextAlign.center,
              ),
              value: selection.id,
            );
          }).toList(),
        )
      )
    );
  }

}

