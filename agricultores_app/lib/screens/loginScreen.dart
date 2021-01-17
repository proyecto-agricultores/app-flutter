import 'package:agricultores_app/screens/registerScreen.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../app_icons.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  String telephone;

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
            vertical: 120.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
              ),
              SizedBox(height: 50),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  IntlPhoneField(
                    decoration: InputDecoration(
                      labelText: 'Número de celular',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(20.0)),
                      ),
                    ),
                    initialCountryCode: 'PE',
                    onChanged: (phone) {
                      telephone = phone.completeNumber;
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                children: [
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.green,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                        borderRadius:
                            const BorderRadius.all(const Radius.circular(20.0)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text('¿No tienes una cuenta?'),
              new GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen())
                  );
                },
                child: new Text(
                  "Regístrate aquí",
                  style: TextStyle(
                    color: Colors.blue[400],
                  ),
                ),
              ),
              SizedBox(height: 30),
              FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
                // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                onPressed: () async {
                  await Token.setToken(TokenType.access, '');
                  await Token.setToken(TokenType.refresh, '');
                  try {
                    await Token.generateOrRefreshToken(telephone, passwordController.text);
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => 
                          Scaffold(
                            appBar: AppBar(
                              title: const Text('Logged In')
                            ),
                        )
                      )
                    );
                  }
                  catch(e) {
                    print(e.toString());
                    return showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Credenciales Incorrectas'),
                          content: Text(
                              'Ingresar nuevamente su correo y contraseña.'),
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
                color: Colors.green[400],
                child: Text('Ingresar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}