import 'package:agricultores_app/models/colorsModel.dart';
import 'package:agricultores_app/screens/changePassword/changePasswordScreen.dart';
import 'package:agricultores_app/services/changePasswordService.dart';
import 'package:agricultores_app/services/codeRegisterService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SendCodeToChangePasswordScreen extends StatefulWidget {
  SendCodeToChangePasswordScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SendCodeToChangePasswordScreenState createState() => _SendCodeToChangePasswordScreenState();
}

class _SendCodeToChangePasswordScreenState extends State<SendCodeToChangePasswordScreen> {
  final passwordController = TextEditingController();
  String phoneNumber;
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
              Container(
                child: Text(
                  "Ingrese el número de la cuenta que desea recuperar",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  )
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: CosechaColors.verdeFuerte,
                  boxShadow: [
                    BoxShadow(color: Colors.green, spreadRadius: 3),
                  ],
                ),
                padding: EdgeInsets.all(10.0),
              ),
              SizedBox(height: 30,),
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
                  phoneNumber = phone.completeNumber;
                },
              ),
              SizedBox(height: 10),
              CosechaGreenButton(
                onPressed: () async {
                  setState(() {
                    this.isLoading = true;
                  });
                  try {
                    await ChangePasswordService.generateCode(phoneNumber);
                    await Navigator.pushReplacement(
                      context, 
                      MaterialPageRoute(builder: (context) => ChangePasswordScreen(phoneNumber: phoneNumber,))
                    );
                  } catch (e) {
                    setState(() {
                      this.isLoading = false;
                    });
                    return showDialog<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Error"),
                          content: Text("Error al generar el código de registro."),
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
                text: "Enviar código", 
                isLoading: isLoading,
              )
            ]
          )
        )
      )
    );
  }
}
