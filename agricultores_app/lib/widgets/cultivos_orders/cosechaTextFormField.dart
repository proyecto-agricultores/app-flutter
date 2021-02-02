import 'package:flutter/material.dart';

class CosechaTextFormField extends StatelessWidget {
  CosechaTextFormField({this.validator, this.text, this.controller, this.unit});
  final validator;
  final text;
  final controller;
  final unit;

  InputDecoration _buildInputDecoration(String placeholder) {
    return InputDecoration(
      labelText: placeholder,
      counterText: "",
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
        borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext buildContext) {
    return TextFormField(
      keyboardType:
          TextInputType.numberWithOptions(
              decimal: true, signed: true),
      controller: controller,
      validator: (value) => value.isEmpty
          ? validator
          : null,
      maxLength: 30,
      decoration: _buildInputDecoration(
          text + unit),
    );
  }
}