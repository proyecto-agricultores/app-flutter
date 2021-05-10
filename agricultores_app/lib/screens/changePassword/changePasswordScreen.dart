import 'package:agricultores_app/models/colorsModel.dart';
import 'package:agricultores_app/services/changePasswordService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:flutter_verification_code/flutter_verification_code.dart';

import '../../main.dart';

class ChangePasswordScreen extends StatefulWidget {
  ChangePasswordScreen({Key key, this.title, @required this.phoneNumber}) : super(key: key);

  final String title;
  final String phoneNumber;

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final passwordController = TextEditingController();
  String phoneNumber;
  String code;
  bool isLoading = false;

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
              CosechaLogo(scale: 5.0),
              SizedBox(height: 50,),
              VerificationCode(
                length: 4,
                onCompleted: (String value) {
                  setState(() {
                    code = value;
                  });
                  print(value);
                },
                onEditing: (bool value) {
                  print("On editing: ${value ? "yes" : "no"}");
                },
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  labelText: 'Nueva contraseña',
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
              SizedBox(height: 20),
              CosechaGreenButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                    final response = await ChangePasswordService.changePassword(code, passwordController.text, phoneNumber);
                    print(response.body);
                    await Token.generateTokenFromUserAndPassword(this.widget.phoneNumber, passwordController.text);
                    await Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp())
                    );
                  } catch (e) {
                    print(e.toString());
                    print(e.toString().substring(11));
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text(e.toString().substring(11)),
                          actions: [
                            TextButton(
                              child: Text('Intentar Nuevamente'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      }
                    );
                  }
                },
                text: "Cambiar contraseña",
                isLoading: isLoading,
              ),
            ]
          )
        )
      )
    );
  }
}
