import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, FilteringTextInputFormatter, SystemChrome, TextInputFormatter;
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dniController = TextEditingController();
  final rucController = TextEditingController();
  final passwordController = TextEditingController();

  String telephone;

  static final TextInputFormatter digitsOnly = FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dniController.dispose();
    rucController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget textField(TextEditingController controller, String placeholder, bool obscureText, IconData icon, int maxLength) {
    return Column(
      children: [
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          enableSuggestions: false,
          autocorrect: false,
          maxLength: maxLength,
          decoration: InputDecoration(
            labelText: placeholder,
            counterText: "",
            prefixIcon: Icon(
              icon,
              color: Colors.green,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
            ),
          ), 
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
            children: <Widget> [
                  Image.asset(
                    'assets/images/logo.png',
                    scale: MediaQuery.of(context).size.height / MediaQuery.of(context).size.width,
                  ),
                  Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      this.textField(firstNameController, 'Nombres', false, Icons.person, 30),
                      this.textField(lastNameController, 'Apellidos', false, Icons.person, 30),
                      this.textField(dniController, 'DNI', false, Icons.call_to_action, 8),
                      this.textField(rucController, 'RUC', false, Icons.call_to_action_outlined, 10),
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
                      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                      this.textField(passwordController, 'Contraseña', true, Icons.lock, 4096),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                        onPressed: () {
                          print(firstNameController.text);
                          print(lastNameController.text);
                          print(dniController.text);
                          print(rucController.text);
                          print(telephone);
                          print(passwordController.text);
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
                )
              // Flexible(
              //   child: 
              //     Image.asset(
              //       'assets/images/logo.png',
              //       scale: MediaQuery.of(context).size.height / MediaQuery.of(context).size.width,
              //     ),
              // ),
              // Flexible(
              //   flex: 3,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * 0.8,
              //     child: Column(
              //       children: [
              //         this.textField(firstNameController, 'Nombres', false, Icons.person, 30),
              //         this.textField(lastNameController, 'Apellidos', false, Icons.person, 30),
              //         this.textField(dniController, 'DNI', false, Icons.call_to_action, 8),
              //         this.textField(rucController, 'RUC', false, Icons.call_to_action_outlined, 10),
              //         IntlPhoneField(
              //           decoration: InputDecoration(
              //             labelText: 'Número de celular',
              //             border: OutlineInputBorder(
              //               borderSide: BorderSide(color: Colors.green),
              //               borderRadius:
              //                   const BorderRadius.all(const Radius.circular(20.0)),
              //             ),
              //           ),
              //           initialCountryCode: 'PE',
              //           onChanged: (phone) {
              //             telephone = phone.completeNumber;
              //           },
              //         ),
              //         SizedBox(height: MediaQuery.of(context).size.height * 0.01),
              //         this.textField(passwordController, 'Contraseña', true, Icons.lock, 4096),
              //         FlatButton(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(18.0),
              //           ),
              //           // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
              //           onPressed: () {
              //             print(firstNameController.text);
              //             print(lastNameController.text);
              //             print(dniController.text);
              //             print(rucController.text);
              //             print(telephone);
              //             print(passwordController.text);
              //           },
              //           color: Colors.green[400],
              //           child: Text('Siguiente',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16,
              //               )),
              //         )
              //       ],
              //     ),
              //   )
              // ),
            ]
          )
        )
      ),
    );
  }
}