import 'package:agricultores_app/screens/register/photoRegisterScreen.dart';
import 'package:agricultores_app/services/codeRegisterService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:flutter_verification_code/flutter_verification_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CodeRegisterScreen extends StatefulWidget {
  CodeRegisterScreen({Key key}) : super(key: key);

  @override
  _CodeRegisterScreenState createState() => _CodeRegisterScreenState();
}

class _CodeRegisterScreenState extends State<CodeRegisterScreen> {
  String code;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    CodeRegisterService.generateCode();
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
        title: Text('Registro'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CosechaLogo(scale: 5.0,),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Text(
                          'Ingrese el código a continuación recibido por mensaje de texto: '),
                      SizedBox(height: 20),
                      VerificationCode(
                        length: 4,
                        onCompleted: (String value) async {
                          setState(() {
                            code = value;
                            isLoading = true;
                          });
                          final response =
                              await CodeRegisterService.sendCode(code);
                          print(response);
                          if (response == "ok") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PhotoRegisterScreen()),
                            );
                          } else if (response == "incorrect-code") {
                            setState(() {
                              isLoading = false;
                            });
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Codigo Incorrecto'),
                                  content: Text(
                                      'Ingresar nuevamente el código recibido por SMM.'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: Text('Intentar Nuevamente'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        onEditing: (bool value) {
                          print(value);
                        },
                      ),
                      SizedBox(height: 40),
                      CosechaGreenButton(
                        onPressed: () async {
                          await CodeRegisterService.generateCode();
                        }, 
                        text: 'Reenviar el código SMS', 
                        isLoading: false,
                       ),
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
