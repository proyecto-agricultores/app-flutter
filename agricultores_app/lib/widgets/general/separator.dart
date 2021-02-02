import 'package:flutter/material.dart';

class Separator extends StatelessWidget {

  Separator({this.height});

  final double height;
  
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * this.height
    );
  }
}