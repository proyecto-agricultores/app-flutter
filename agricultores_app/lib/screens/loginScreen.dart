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
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                    onPressed: null,
                    child: Column(
                      children: <Widget>[
                        Icon(
                          AppIcons.seedling,
                          size: 70,
                          color: Colors.black54,
                        ),
                        Text("Agricultor")
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: null,
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.person_search,
                          size: 70,
                          color: Colors.black54,
                        ),
                        Text("Comprador")
                      ],
                    ),
                  ),
                  FlatButton(
                    onPressed: null,
                    child: Column(
                      children: <Widget>[
                        Icon(
                          Icons.ad_units,
                          size: 70,
                          color: Colors.black54,
                        ),
                        Text("Anunciante")
                      ],
                    ),
                  ),
                ],
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
                onTap: () {print('registrese');},
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
                // onPressed: Token.generateOrRefreshToken(),
                onPressed: () {
                  print(telephone);
                  print(passwordController.text);
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
