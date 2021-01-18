import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:intl_phone_field/intl_phone_field.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  String telephone;
  bool dniOrRuc = false;
  final dniOrRucController = TextEditingController();
  final passwordController = TextEditingController();

  InputDecoration _buildInputDecoration(String placeholder) {
    return InputDecoration(
      labelText: placeholder,
      counterText: "",
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green),
        borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
      ),
    );
  }

  Widget _buildFirstName() {
    return Column(
      children: [
        TextFormField(
          controller: firstNameController,
          validator: (value) => value.isEmpty ? "El campo Nombres no puede ser vacío" : null,
          maxLength: 30,
          decoration: _buildInputDecoration("Nombres"),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ]
    );
  }
  
  Widget _buildLastName() {
    return Column(
      children: [
        TextFormField(
          controller: lastNameController,
          validator: (value) => value.isEmpty ? "El campo Apellidos no puede ser vacío" : null,
          maxLength: 30,
          decoration: _buildInputDecoration("Apellidos"),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ]
    );
  }

  Widget _buildTelephoneNumber() {
    return Column(
      children: [
        IntlPhoneField(
          validator: (value) => value.isEmpty ? "El campo Número no puede ser vacío" : null,
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
      ],
    );
  }

  Widget _buildDniOrRuc() {
    return Column(
      children: [
        Row(
          children: [
            DropdownButton(
              value: this.dniOrRuc,
              items: [
                DropdownMenuItem(
                  child: Text("DNI"),
                  value: false,
                ),
                DropdownMenuItem(
                  child: Text("RUC"),
                  value: true,
                ),
              ],
              onChanged: (value) {
                setState(() {
                  this.dniOrRuc = value;
                });
              }
            ),
            Expanded(
              child: Column(
                children: [
                  TextFormField(
                    controller: dniOrRucController,
                    validator: (value) => value.isEmpty ? 
                      (this.dniOrRuc ? "El campo DNI no puede ser vacío" : "El campo RUC no puede ser vacío") : null,
                    maxLength: this.dniOrRuc ? 10 : 8,
                    decoration: _buildInputDecoration(this.dniOrRuc ? "RUC" : "DNI"),
                  ),
                ]
              ),
            ), 
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      children: [
        TextFormField(
          controller: passwordController,
          obscureText: true,
          validator: (value) => value.isEmpty ? "El campo Contraseña no puede ser vacío" : null,
          maxLength: 30,
          decoration: _buildInputDecoration("Contraseña"),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ]
    ); 
  }

  Widget _nextButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
      onPressed: () {
        print(firstNameController.text);
        print(lastNameController.text);
        print(dniOrRucController.text);
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
    );

  Widget _logo() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Image.asset(
          'assets/images/logo.png',
          scale: MediaQuery.of(context).size.height / MediaQuery.of(context).size.width,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      ],
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
        body: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: 40.0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth, minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    this._logo(),
                    Expanded(
                      child: Column(
                        children: [
                          this._buildFirstName(),
                          this._buildLastName(),
                          this._buildTelephoneNumber(),
                          this._buildDniOrRuc(),
                          this._buildPassword(),
                        ],
                      ),
                    ),
                    this._nextButton(),
                  ]
                ),
              )
            ),
          );
        }
      ),
    );
  }
}
