import 'package:flutter/material.dart';

class CosechaLoading extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      child: CircularProgressIndicator()
    );
  }

}

