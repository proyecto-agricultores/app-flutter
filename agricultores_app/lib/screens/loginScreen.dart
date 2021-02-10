import 'package:agricultores_app/screens/cultivos/crearCutivoScreen.dart';
import 'package:agricultores_app/screens/homeScreen.dart';
import 'package:agricultores_app/screens/orders/createOrderScreen.dart';
import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/screens/register/registerScreen.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/widgets/cultivos_orders/unitDropdown.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:agricultores_app/widgets/test_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final passwordController = TextEditingController();
  String telephone;
  bool isLoading = false;

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
              CosechaLogo(scale: 5.0,),
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
                      MaterialPageRoute(
                          builder: (context) => RegisterScreen()));
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
                  setState(() {
                    this.isLoading = true;
                  });
                  await Token.setToken(TokenType.access, '');
                  await Token.setToken(TokenType.refresh, '');
                  try {
                    await Token.generateTokenFromUserAndPassword(
                        telephone, passwordController.text);
                    final user = await MyProfileService.getLoggedinUser();
                    if (!user.isVerified) {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CodeRegisterScreen()),
                      );
                    } else if (user.ubigeo == "") {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LocationRegisterScreen()),
                      );
                    } else if (user.role == null) {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => RoleRegisterScreen()),
                      );
                    } else {
                      await Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      this.isLoading = false;
                    });
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
                child: this.isLoading
                    ? LinearProgressIndicator(
                        minHeight: 5,
                      )
                    : Text(
                        'Ingresar',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
