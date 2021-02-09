import 'package:agricultores_app/services/updateRolService.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import '../../app_icons.dart';
import '../homeScreen.dart';

class RolRegisterScreen extends StatefulWidget {
  RolRegisterScreen({Key key}) : super(key: key);

  @override
  _RolRegisterScreenState createState() => _RolRegisterScreenState();
}

class _RolRegisterScreenState extends State<RolRegisterScreen> {
  String code;

  Widget _roleButton(String roleAbbreviation, String fullRole, IconData icon) {
    return FlatButton(
      onPressed: () {
        UpdateRolService.updateRol(roleAbbreviation);
        Navigator.of(context)
            .popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomeScreen()),
        );
      },
      child: Column(
        children: <Widget>[
          Icon(
            icon,
            size: MediaQuery.of(context).size.width * 0.2,
            color: Colors.black54,
          ),
          Text(fullRole)
        ],
      ),
    );
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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CosechaLogo(scale: 5.0),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text('Seleccione su rol:'),
                      SizedBox(height: 40),
                      this._roleButton("ag", "Agricultor", AppIcons.seedling),
                      SizedBox(height: 15),
                      this._roleButton("co", "Comprador", Icons.person_search),
                      SizedBox(height: 25),
                      this._roleButton("an", "Anunciante", Icons.ad_units),
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
