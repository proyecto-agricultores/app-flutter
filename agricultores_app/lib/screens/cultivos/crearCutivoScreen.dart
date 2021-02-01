import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'
    show
        DeviceOrientation,
        FilteringTextInputFormatter,
        SystemChrome,
        TextInputFormatter;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class CrearCultivoScreen extends StatefulWidget {
  const CrearCultivoScreen({
    Key key,
  }) : super(key: key);

  @override
  _CrearCultivoScreenState createState() => _CrearCultivoScreenState();
}

class _CrearCultivoScreenState extends State<CrearCultivoScreen> {
  _CrearCultivoScreenState();
  bool isLoading = false;

  List<File> _images = List<File>();

  final picker = ImagePicker();

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

  Future getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(
      () {
        if (pickedFile != null) {
          _images.add(File(pickedFile.path));
        } else {
          print('No image selected.');
        }
      },
    );
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

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
        title: Text('Crear Cultivo'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  _images.isNotEmpty
                      ? Container(
                          child: CarouselSlider(
                            options: CarouselOptions(
                              height: 200.0,
                              viewportFraction: 0.6,
                              enableInfiniteScroll: false,
                              enlargeCenterPage: true,
                            ),
                            items: _images
                                .map(
                                  (item) => Container(
                                    height: 500.0,
                                    decoration: new BoxDecoration(
                                      color: const Color(0xff7c94b6),
                                      image: DecorationImage(
                                        image: new FileImage(item),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                      : Container(),
                  SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Agregar Imágenes: "),
                      SizedBox(width: 10),
                      FloatingActionButton(
                        onPressed: () => getImage(ImageSource.camera),
                        tooltip: 'Pick Image',
                        child: Icon(Icons.add_a_photo),
                        heroTag: 'camera',
                      ),
                      SizedBox(width: 10),
                      FloatingActionButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        tooltip: 'Pick Image From Library',
                        child: Icon(Icons.photo_library),
                        heroTag: 'library',
                      )
                    ],
                  ),
                  SizedBox(height: 50),
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
                                      decoration:
                                          _buildInputDecoration("Cantidad"),
                                    ),
                                    this._separator(),
                                    TextFormField(
                                      keyboardType:
                                          TextInputType.numberWithOptions(
                                              decimal: true, signed: true),
                                      controller: unitPriceController,
                                      validator: (value) => value.isEmpty
                                          ? "El campo Nombres no puede ser vacío"
                                          : null,
                                      maxLength: 30,
                                      decoration: _buildInputDecoration(
                                          "Precio unitario"),
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
                                    SizedBox(height: 20),
                                    Container(
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            setState(() {
                                              this.isLoading = true;
                                            });
                                            try {
                                              // final update =
                                              //     await MyPubService.update(
                                              //   this.cultivoId,
                                              //   null,
                                              //   this.unitValue,
                                              //   int.parse(
                                              //     quantityController.text,
                                              //   ),
                                              //   formatter.parse(
                                              //       harvestDateController.text),
                                              //   formatter.parse(
                                              //       sowingDateController.text),
                                              //   double.parse(
                                              //     unitPriceController.text,
                                              //   ),
                                              // );

                                              // setState(() {
                                              //   this.isLoading = false;
                                              // });
                                              // return showDialog<void>(
                                              //   context: context,
                                              //   barrierDismissible: true,
                                              //   builder: (BuildContext context) {
                                              //     return AlertDialog(
                                              //       title: Text(
                                              //           'Cambios realizados correctamente.'),
                                              //       content: Text(
                                              //           'Se acaba de actualizar el cultivo con nuevos datos.'),
                                              //       actions: <Widget>[
                                              //         TextButton(
                                              //           child: Text('OK!'),
                                              //           onPressed: () {
                                              //             Navigator.of(context)
                                              //                 .popUntil((route) =>
                                              //                     route.isFirst);
                                              //           },
                                              //         ),
                                              //       ],
                                              //     );
                                              //   },
                                              // );
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
                                                'Crear Cultivo',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                      ),
                                    ),
                                    SizedBox(height: 100),
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
        ],
      ),
    );
  }
}
