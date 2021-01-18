import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'package:flutter_verification_code/flutter_verification_code.dart';

class CodeRegisterScreen extends StatefulWidget {
  CodeRegisterScreen({Key key}) : super(key: key);

  @override
  _CodeRegisterScreenState createState() => _CodeRegisterScreenState();
}

class _CodeRegisterScreenState extends State<CodeRegisterScreen> {
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
      appBar: AppBar(
        title: Text('Registro'),
      ),
      body: Center(
          child: SingleChildScrollView(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
            //Flexible(
            //child:
            Image.asset(
              'assets/images/logo.png',
              scale: MediaQuery.of(context).size.height /
                  MediaQuery.of(context).size.width,
              //),
            ),
            Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      VerificationCode(
                        length: 4,
                        onCompleted: (String value) {
                          setState(() {
                            code = value;
                          });
                          print(value);
                        },
                        onEditing: (bool value) {
                          print(value);
                        },
                      ),
                      SizedBox(height: 40),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                        onPressed: () {
                          print(code);
                        },
                        color: Colors.green[400],
                        child: Text('Siguiente',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      )
                    ],
                  ),
                )),
          ]))),
    );
  }
}
