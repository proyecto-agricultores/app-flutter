import 'package:agricultores_app/models/colorsModel.dart';
import 'package:agricultores_app/screens/loadingScreen.dart';
import 'package:agricultores_app/screens/homeScreen.dart';
import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'MyColors.dart';
import 'screens/loginScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  _setRole(role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', role);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cosecha',
      theme: ThemeData(
        primaryColor: CosechaColors.verdeFuerte,
        accentColor: CosechaColors.verdeSuave,
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: FutureBuilder(
        future: MyProfileService.getLoggedinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data;
            _setRole(user.role);
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
