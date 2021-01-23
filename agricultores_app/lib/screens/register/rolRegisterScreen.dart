import 'package:agricultores_app/services/updateRolService.dart';
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
      // appBar: AppBar(
      //   title: Text('Registro'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                scale: MediaQuery.of(context).size.height /
                    MediaQuery.of(context).size.width,
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text('Seleccione su rol:'),
                      SizedBox(height: 40),
                      FlatButton(
                        onPressed: () {
                          UpdateRolService.updateRol("ag");
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
                              AppIcons.seedling,
                              size: MediaQuery.of(context).size.width * 0.2,
                              color: Colors.black54,
                            ),
                            Text("Agricultor")
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      FlatButton(
                        onPressed: () {
                          UpdateRolService.updateRol("co");
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
                              Icons.person_search,
                              size: 90,
                              color: Colors.black54,
                            ),
                            Text("Comprador")
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      FlatButton(
                        onPressed: () {
                          UpdateRolService.updateRol('an');
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
                              Icons.ad_units,
                              size: 80,
                              color: Colors.black54,
                            ),
                            Text("Anunciante")
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
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
