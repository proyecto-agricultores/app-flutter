//import 'package:agricultores_app/screens/filters/filterCropsAndOrdersScreen.dart';
import 'package:agricultores_app/screens/loginScreen.dart';
import 'package:agricultores_app/screens/profileScreen.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:shared_preferences/shared_preferences.dart';

import 'buscadorAgricultoresScreen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = await prefs.get('role');
    return role;
  }

  
  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CosechaLogo(),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      CosechaGreenButton(
                        onPressed: () async {
                          final role = await this._getRole();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(role: role)
                            ),
                          );
                        },
                        text: 'Profile',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          final role = await this._getRole();
                          final title = role == 'ag' ? 'Buscar órdenes' : 'Buscar cultivos';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              //builder: (context) => FilterCropsAndOrdersScreen(title: title, role: role)
                                builder: (context) => buscadorAgricultoresScreen(role: role)

                            ),
                          );
                        },
                        text: 'Buscar',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          Token.logout();
                          return Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen()
                            ),
                          );
                        },
                        text: 'Logout',
                        isLoading: false,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
