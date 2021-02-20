import 'package:flutter/material.dart';

class CosechaGreenButton extends StatelessWidget {

  CosechaGreenButton({this.onPressed, this.text, this.isLoading});

  final onPressed;
  final text;
  final isLoading;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: this.onPressed,
      color: Colors.green[400],
      child: this.isLoading
      ? LinearProgressIndicator(minHeight: 5,)
      : Text(
        this.text,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        )
      )
    );
  }
  
}