import 'package:flutter/material.dart';

class CosechaCalendar extends StatelessWidget {
  CosechaCalendar({this.updateDate, this.controller, this.selectedDate, this.label});
  
  _selectDate(BuildContext context, DateTime selectedDate,
      TextEditingController _dateController) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      updateDate(picked, _dateController);
    }
  }
  
  final updateDate;
  final controller;
  final selectedDate;
  final label;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(
        context,
        selectedDate,
        controller,
      ),
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            icon: Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (value.isEmpty)
              return "Por favor ingresar una fecha.";
            return null;
          },
        ),
      ),
    );
  }
}