import 'package:agricultores_app/screens/loadingScreen.dart';
import 'package:agricultores_app/screens/homeScreen.dart';
import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:flutter/material.dart';
import 'MyColors.dart';
import 'screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

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
        future: MyProfileService.getLoggedinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            if (!user.isVerified) {
              return CodeRegisterScreen();
            } else if (user.ubigeo == "") {
              return LocationRegisterScreen();
            } else if (user.role == null) {
              return RoleRegisterScreen();
            } else {
              return HomeScreen();
            }
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
