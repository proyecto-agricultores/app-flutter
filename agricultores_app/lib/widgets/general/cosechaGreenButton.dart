import 'package:agricultores_app/models/colorsModel.dart';
import 'package:flutter/material.dart';

class CosechaGreenButton extends StatelessWidget {

  CosechaGreenButton({
    @required this.onPressed, 
    @required this.text, 
    @required this.isLoading,
  });

  final onPressed;
  final String text;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: this.isLoading ? null : this.onPressed,
      color: CosechaColors.verdeFuerte,
      child: this.isLoading
      ? LinearProgressIndicator(minHeight: 5,)
      : Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )
      ),
      disabledColor: CosechaColors.verdeFuerte,
    );
  }
  
}