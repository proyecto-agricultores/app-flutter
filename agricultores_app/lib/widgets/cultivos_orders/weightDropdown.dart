import 'package:flutter/material.dart';

class WeightDropdown extends StatefulWidget {
  WeightDropdown({this.weight});
  final weight;
  
  @override
  State<StatefulWidget> createState() => _WeightDropdownState(this.weight);
}

class _WeightDropdownState extends State<WeightDropdown> {
  _WeightDropdownState(this._weight);
  var _weight;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: this._weight,
      icon: Icon(Icons.arrow_downward),
      onChanged: (String newValue) {
        setState(() {
          this._weight = newValue;
        });
      },
      items: <String>[
        'kg',
        'ton',
      ].map<DropdownMenuItem<String>>(
          (String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}