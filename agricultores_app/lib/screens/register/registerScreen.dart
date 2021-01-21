import 'package:agricultores_app/screens/register/codeRegisterScreen.dart';
import 'package:agricultores_app/services/authService.dart';
import 'package:agricultores_app/services/codeRegisterService.dart';
import 'package:agricultores_app/services/registerService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show
        DeviceOrientation,
        FilteringTextInputFormatter,
        SystemChrome,
        TextInputFormatter;
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
  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
  static final TextInputFormatter lettersOnly =
      FilteringTextInputFormatter.allow(RegExp(r'^[^0-9]+$'));
  bool isLoading = false;

  final _formKey = new GlobalKey<FormState>();

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
    return Column(children: [
      TextFormField(
        keyboardType: TextInputType.name,
        inputFormatters: [lettersOnly],
        controller: firstNameController,
        validator: (value) =>
            value.isEmpty ? "El campo Nombres no puede ser vacío" : null,
        maxLength: 30,
        decoration: _buildInputDecoration("Nombres"),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
    ]);
  }

  Widget _buildLastName() {
    return Column(children: [
      TextFormField(
        keyboardType: TextInputType.name,
        inputFormatters: [lettersOnly],
        controller: lastNameController,
        validator: (value) =>
            value.isEmpty ? "El campo Apellidos no puede ser vacío" : null,
        maxLength: 30,
        decoration: _buildInputDecoration("Apellidos"),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
    ]);
  }

  Widget _buildTelephoneNumber() {
    return Column(
      children: [
        IntlPhoneField(
          validator: (value) =>
              value.isEmpty ? "El campo Número no puede ser vacío" : null,
          inputFormatters: [digitsOnly],
          decoration: InputDecoration(
            labelText: 'Número de celular',
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.green),
              borderRadius: const BorderRadius.all(const Radius.circular(20.0)),
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
                    this.dniOrRucController.text = '';
                  });
                }),
            Expanded(
              child: Column(children: [
                TextFormField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [digitsOnly],
                  controller: dniOrRucController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return this.dniOrRuc
                          ? "El campo RUC no puede ser vacío"
                          : "El campo DNI no puede ser vacío";
                    } else if (this.dniOrRuc && value.length < 10) {
                      return "Su RUC está incompleto";
                    } else if (!this.dniOrRuc && value.length < 8) {
                      return "Su DNI está incompleto";
                    } else {
                      return null;
                    }
                  },
                  maxLength: this.dniOrRuc ? 10 : 8,
                  decoration: _buildInputDecoration(""),
                ),
              ]),
            ),
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(children: [
      TextFormField(
        controller: passwordController,
        obscureText: true,
        validator: (value) =>
            value.isEmpty ? "El campo Contraseña no puede ser vacío" : null,
        maxLength: 4096,
        decoration: _buildInputDecoration("Contraseña"),
      ),
      SizedBox(height: MediaQuery.of(context).size.height * 0.01),
    ]);
  }

  Widget _nextButton() {
    return Container(
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            setState(() {
              this.isLoading = true;
            });
            try {
              final register = await RegisterService.createUser(
                firstNameController.text,
                lastNameController.text,
                telephone,
                dniOrRucController.text,
                passwordController.text,
                dniOrRuc
              );
              setState(() {
                this.isLoading = false;
              });
              print(register);
              print(telephone);
              print(passwordController.text);
              if (register == 'phone already in use') {
                return showDialog<void>(
                  context: context,
                  barrierDismissible: true,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Número de teléfono ya registrado'),
                      content: Text('Ya existe una cuenta registrada con el número de teléfono ingresado. Intente hacer log-in'),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Aceptar'),
                          onPressed: () {
                            Navigator.of(context).popUntil((route) => route.isFirst);
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (register == 'ok') {
                await Token.generateOrRefreshToken(telephone, passwordController.text);
                await CodeRegisterService.generateCode();
                Navigator.push(context, MaterialPageRoute(builder: (context) => CodeRegisterScreen()));
              }
            } catch (e) {
              print(e.toString());
            }
          }
        },
        color: Colors.green[400],
        child: this.isLoading
          ? LinearProgressIndicator(
            minHeight: 5,
          )
          : Text('Siguiente',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            )
          ),
      )
    );
  }

  Widget _logo() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Image.asset(
          'assets/images/logo.png',
          scale: MediaQuery.of(context).size.height /
              MediaQuery.of(context).size.width,
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
    if (this.isLoading) {
      return Container(
        child: Text('loading')
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Registro'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 40.0,
          ),
          child: Column(
            children: [
              this._logo(),
              this._buildTelephoneNumber(),
              Form(
                key: _formKey,
                child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      this._buildFirstName(),
                      this._buildLastName(),
                      this._buildDniOrRuc(),
                      this._buildPassword(),
                      this._nextButton(),
                    ],
                  ),
                )
              ),
            ],
          )
        ),
      );
    }
  }
}
