import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show
        DeviceOrientation,
        FilteringTextInputFormatter,
        SystemChrome,
        TextInputFormatter;
import 'package:intl/intl.dart';

class EditarCultivoScreen extends StatefulWidget {
  final int cultivoId;
  final String titulo;
  final dataCultivo;

  const EditarCultivoScreen({
    Key key,
    @required this.cultivoId,
    @required this.titulo,
    @required this.dataCultivo,
  }) : super(key: key);

  @override
  _EditarCultivoScreenState createState() => _EditarCultivoScreenState(
        cultivoId,
        titulo,
        dataCultivo,
      );
}

class _EditarCultivoScreenState extends State<EditarCultivoScreen> {
  final int cultivoId;
  final String titulo;
  final dataCultivo;

  _EditarCultivoScreenState(
    this.cultivoId,
    this.titulo,
    this.dataCultivo,
  );
  bool isLoading = false;

  DateTime selectedHarvestDate = DateTime.now();
  DateTime selectedSowingDate = DateTime.now();

  final suppliesController = TextEditingController();
  final pictureURLController = TextEditingController();
  final quantityController = TextEditingController();
  final unitPriceController = TextEditingController();
  final harvestDateController = TextEditingController();
  final sowingDateController = TextEditingController();
  String unitValue = "Kg";

  final _formKey = new GlobalKey<FormState>();

  static final TextInputFormatter digitsOnly =
      FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));

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

  SizedBox _separator() {
    return SizedBox(height: MediaQuery.of(context).size.height * 0.01);
  }

  _selectDate(BuildContext context, DateTime selectedDate,
      TextEditingController _dateController) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate)
      setState(
        () {
          selectedDate = picked;
          var date =
              "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
          _dateController.text = date;
        },
      );
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();
    quantityController.text = dataCultivo.quantity.toString();
    unitPriceController.text = dataCultivo.unitPrice.toString();
    harvestDateController.text = formatter.format(dataCultivo.harvestDate);
    sowingDateController.text = formatter.format(dataCultivo.sowingDate);
    unitValue = dataCultivo.unit;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar: ' + titulo),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Column(
                              children: [
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [digitsOnly],
                                  controller: quantityController,
                                  validator: (value) => value.isEmpty
                                      ? "El campo Nombres no puede ser vacío"
                                      : null,
                                  maxLength: 30,
                                  decoration: _buildInputDecoration("Cantidad"),
                                ),
                                this._separator(),
                                TextFormField(
                                  keyboardType: TextInputType.numberWithOptions(
                                      decimal: true, signed: true),
                                  controller: unitPriceController,
                                  validator: (value) => value.isEmpty
                                      ? "El campo Nombres no puede ser vacío"
                                      : null,
                                  maxLength: 30,
                                  decoration:
                                      _buildInputDecoration("Precio unitario"),
                                ),
                                DropdownButton<String>(
                                  value: unitValue,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      unitValue = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'Kg',
                                    'g',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                GestureDetector(
                                  onTap: () => _selectDate(
                                    context,
                                    selectedHarvestDate,
                                    harvestDateController,
                                  ),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      // onSaved: (val) {
                                      //   task.date = selectedHarvestDate;
                                      // },
                                      controller: harvestDateController,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de Cosecha",
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Please enter a date for your task";
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                this._separator(),
                                GestureDetector(
                                  onTap: () => _selectDate(
                                    context,
                                    selectedSowingDate,
                                    sowingDateController,
                                  ),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: sowingDateController,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de Siembra",
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Please enter a date for your task";
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                this._separator(),
                                Container(
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
                                          final update =
                                              await MyPubService.update(
                                            this.cultivoId,
                                            null,
                                            this.unitValue,
                                            int.parse(
                                              quantityController.text,
                                            ),
                                            formatter.parse(
                                                harvestDateController.text),
                                            formatter.parse(
                                                sowingDateController.text),
                                            double.parse(
                                              unitPriceController.text,
                                            ),
                                          );

                                          setState(() {
                                            this.isLoading = false;
                                          });
                                          return showDialog<void>(
                                            context: context,
                                            barrierDismissible: true,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(
                                                    'Cambios realizados correctamente.'),
                                                content: Text(
                                                    'Se acaba de actualizar el cultivo con nuevos datos.'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('OK!'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .popUntil((route) =>
                                                              route.isFirst);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        } catch (e) {
                                          throw e;
                                        }
                                      }
                                    },
                                    color: Colors.green[400],
                                    child: this.isLoading
                                        ? LinearProgressIndicator(
                                            minHeight: 5,
                                          )
                                        : Text(
                                            'Guardar Cambios',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
