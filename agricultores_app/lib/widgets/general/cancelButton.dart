import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18)
      ),
      onPressed: () async {
        Navigator.pop(context);
      },
      color: Colors.red[400],
      child: Text(
          'Cancelar',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16
          )
        )
    );
  }
}