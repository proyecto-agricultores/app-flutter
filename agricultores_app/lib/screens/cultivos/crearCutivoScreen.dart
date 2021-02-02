import 'dart:io';
import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/models/supplyModel.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/services/supplysService.dart';
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
  final areaController = TextEditingController();
  final unitPriceController = TextEditingController();
  final harvestDateController = TextEditingController();
  final sowingDateController = TextEditingController();
  String weightUnit = "kg";
  String areaUnit = "hm2";
  int supplyID = 1;

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
                                    FutureBuilder(
                                      future: SupplyService.getSupplys(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return Center(
                                              child:
                                                  CircularProgressIndicator());
                                        } else {
                                          List<Supply> listResponse =
                                              snapshot.data;
                                          return DropdownButton(
                                            value: supplyID,
                                            icon: Icon(Icons.arrow_downward),
                                            onChanged: (newValue) {
                                              setState(() {
                                                supplyID = newValue;
                                              });
                                            },
                                            items: listResponse.map((item) {
                                              return DropdownMenuItem(
                                                child: Text(item.name),
                                                value: item.id,
                                              );
                                            }).toList(),
                                          );
                                        }
                                      },
                                    ),
                                    this._separator(),
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
                                      keyboardType:
                                          TextInputType.numberWithOptions(
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
                                              final crearCultivoResponse =
                                                  await MyPubService.create(
                                                supplyID,
                                                MyPub(
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

                                              for (var image in _images) {
                                                await MyPubService
                                                    .appendPubPicture(
                                                        crearCultivoResponse.id,
                                                        image.path);
                                              }

                                              setState(() {
                                                this.isLoading = false;
                                              });
                                              return showDialog<void>(
                                                context: context,
                                                barrierDismissible: true,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                        'Cultivo creado correctamente.'),
                                                    content: Text(
                                                        'Se acaba de crear el cultivo. Ahora lo podrás encontrar en tu perfil.'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        child: Text('OK!'),
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .popUntil((route) =>
                                                                  route
                                                                      .isFirst);
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
