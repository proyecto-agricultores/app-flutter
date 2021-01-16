import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../app_icons.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Text(
              //   'You have pushed the button this many times:',
              // ),
              // Text(
              //   '$_counter',
              //   style: Theme.of(context).textTheme.headline4,
              // ),
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
                    //padding: EdgeInsets.all(50.0),
                    child: Column(
                      // Replace with a Row for horizontal icon + text
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
              SizedBox(
                width: 300,
                child: IntlPhoneField(
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
                    //print(phone.completeNumber);
                  },
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
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
              ),
              SizedBox(height: 30),
              Text('¿No tienes una cuenta?'),
              new GestureDetector(
                onTap: () {},
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
                onPressed: () {},
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
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
