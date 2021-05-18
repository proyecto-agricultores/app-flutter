import 'package:agricultores_app/models/colorsModel.dart';
import 'package:agricultores_app/screens/changePassword/sendCodeToChangePasswordScreen.dart';
import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/screens/register/registerScreen.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homeScreen.dart';

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

  customGestureDetector(screen, text) {
    return  new GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => screen));
      },
      child: new Text(
        text,
        style: TextStyle(
          color: Colors.blue[400],
        ),
      ),
    );
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
                        color: CosechaColors.verdeFuerte,
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
              customGestureDetector(RegisterScreen(), "Regístrate aquí"),
              SizedBox(height: 15,),
              customGestureDetector(SendCodeToChangePasswordScreen(), "Olvidé mi contraseña"),
              SizedBox(height: 30),
              CosechaGreenButton(
                text: 'Ingresar',
                isLoading: this.isLoading,
                onPressed: () async {
                  setState(() {
                    this.isLoading = true;
                  });
                  await Token.setToken(TokenType.access, '');
                  await Token.setToken(TokenType.refresh, '');
                  try {
                    await Token.generateTokenFromUserAndPassword(
                        telephone, passwordController.text);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    final user = await MyProfileService.getLoggedinUser();
                    await prefs.setString('role', user.role);
                    await Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) {
                        if (!user.isVerified) {
                          return CodeRegisterScreen();
                        } else if (user.ubigeo == "") {
                          return LocationRegisterScreen();
                        } else if (user.role == null) {
                          return RoleRegisterScreen();
                        } else {
                          return HomeScreen();
                        }  
                      })
                    );
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
                              'Ingresar nuevamente su número y contraseña.'),
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
                } 
              ),
            ],
          ),
        ),
      ),
    );
  }
}
