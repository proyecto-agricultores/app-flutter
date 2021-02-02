import 'package:agricultores_app/models/myPubModel.dart';
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
  final pictureURLsController = TextEditingController();
  final areaController = TextEditingController();
  final unitPriceController = TextEditingController();
  final harvestDateController = TextEditingController();
  final sowingDateController = TextEditingController();
  String weightUnit = "kg";
  String areaUnit = "hm2";

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
    weightUnit = dataCultivo.weightUnit;
    unitPriceController.text = dataCultivo.unitPrice.toString();
    areaUnit = dataCultivo.areaUnit;
    areaController.text = dataCultivo.area.toString();
    harvestDateController.text = formatter.format(dataCultivo.harvestDate);
    sowingDateController.text = formatter.format(dataCultivo.sowingDate);
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
                                DropdownButton<String>(
                                  value: weightUnit,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      weightUnit = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'kg',
                                    'ton',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
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
                                  decoration: _buildInputDecoration(
                                      "Precio unitario x " + weightUnit),
                                ),
                                this._separator(),
                                DropdownButton<String>(
                                  value: areaUnit,
                                  icon: Icon(Icons.arrow_downward),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      areaUnit = newValue;
                                    });
                                  },
                                  items: <String>[
                                    'hm2',
                                    'm2',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                this._separator(),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [digitsOnly],
                                  controller: areaController,
                                  validator: (value) => value.isEmpty
                                      ? "El campo Nombres no puede ser vacío"
                                      : null,
                                  maxLength: 30,
                                  decoration: _buildInputDecoration(
                                      "Área en " + areaUnit),
                                ),
                                this._separator(),
                                GestureDetector(
                                  onTap: () => _selectDate(
                                    context,
                                    selectedHarvestDate,
                                    harvestDateController,
                                  ),
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      controller: harvestDateController,
                                      decoration: InputDecoration(
                                        labelText: "Fecha de Cosecha",
                                        icon: Icon(Icons.calendar_today),
                                      ),
                                      validator: (value) {
                                        if (value.isEmpty)
                                          return "Por favor ingresar una fecha.";
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
                                          return "Por favor ingresar una fecha.";
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
                                            MyPub(
                                              id: this.cultivoId,
                                              supplieName: null,
                                              pictureURLs: null,
                                              weightUnit: this.weightUnit,
                                              unitPrice: double.parse(
                                                unitPriceController.text,
                                              ),
                                              areaUnit: this.areaUnit,
                                              area: double.parse(
                                                areaController.text,
                                              ),
                                              harvestDate: formatter.parse(
                                                harvestDateController.text,
                                              ),
                                              sowingDate: formatter.parse(
                                                sowingDateController.text,
                                              ),
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
