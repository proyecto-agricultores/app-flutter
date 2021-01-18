import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/screens/register/photoRegisterScreen.dart';
import 'package:flutter/material.dart';

import 'MyColors.dart';
import 'screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: MyColors.getColorsFromHex(0xFF09B44D),
        accentColor: MyColors.getColorsFromHex(0xFF093AC3),
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: LocationRegisterScreen(),
    );
  }
}
