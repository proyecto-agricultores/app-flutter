import 'package:agricultores_app/screens/filters/filterCropsAndOrdersScreen.dart';
import 'package:agricultores_app/screens/filters/filterFarmersAndClientsScreen.dart';
import 'package:agricultores_app/screens/buscadorCompradoresScreen.dart';
import 'package:agricultores_app/screens/loginScreen.dart';
import 'package:agricultores_app/screens/profileScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterCropsAndOrdersScreen(title: "Buscar cultivos", role: "ag")
                            ),
                          );
                        },
                        text: 'Buscar cultivos',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterCropsAndOrdersScreen(title: "Buscar pedidos", role: "co")
                            ),
                          );
                        },
                        text: 'Buscar pedidos',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterFarmersAndClientsScreen(title: "Buscar agricultores", role: "ag")
                            ),
                          );
                        },
                        text: 'Buscar agricultores',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilterFarmersAndClientsScreen(title: "Buscar compradores", role: "co")
                            ),
                          );
                        },
                        text: 'Buscar compradores',
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        onPressed: () async {
                          return Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationRegisterScreen()
                            ),
                          );
                        },
                        text: 'Location',
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
