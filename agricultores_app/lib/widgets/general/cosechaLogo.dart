import 'package:flutter/material.dart';

class CosechaLogo extends StatelessWidget {
  CosechaLogo({this.scale});

  final scale;

  @override
  Widget build(BuildContext context) {
    return Image.asset('assets/images/logo.png', scale: this.scale);
  }
}
