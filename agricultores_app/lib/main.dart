import 'package:agricultores_app/screens/loadingScreen.dart';
import 'package:agricultores_app/screens/homeScreen.dart';
import 'package:agricultores_app/services/helloWorldService.dart';
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
      home: FutureBuilder(
        future: HelloWorldService.getHelloWorld(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return HomeScreen();
          } else if (snapshot.hasError) {
            return LoginScreen();
          } else {
            return LoadingScreen();
          }
        },
      ),
    );
  }
}
