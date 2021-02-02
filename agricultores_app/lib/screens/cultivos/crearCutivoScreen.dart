import 'dart:io';
import 'package:agricultores_app/models/areaUnitModel.dart';
import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/models/priceUnitModel.dart';
import 'package:agricultores_app/models/supplyModel.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/services/supplysService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaCalendar.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaTextFormField.dart';
import 'package:agricultores_app/widgets/cultivos_orders/imageCarouselWidget.dart';
import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/widgets/cultivos_orders/unitDropdown.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
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

  updateDate(DateTime picked, TextEditingController dateController) {
    setState(() {
        var date = "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        dateController.text = date;
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

  _onPressed() async {
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
                  ImageCarousel(images: this._images, getImage: this.getImage),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SupplyDropdown(
                          supplyID: this.supplyID,
                          updateSupply: (newValue) => setState(() {this.supplyID = newValue;})
                        ),
                        Separator(height: 0.01),
                        UnitDropdown(
                          initialUnit: this.weightUnit,
                          updateUnit: (newValue) => setState(() {this.weightUnit = newValue;}),
                          items: PriceUnit.getPriceUnits()
                        ),
                        Separator(height: 0.01),
                        CosechaTextFormField(
                          validator: "El campo Precio no puede ser vacío",
                          text: "Precio unitario x ",
                          controller: this.unitPriceController,
                          unit: this.weightUnit,
                        ),
                        Separator(height: 0.01),
                        UnitDropdown(
                          initialUnit: this.areaUnit,
                          updateUnit: (newValue) => setState(() {this.areaUnit = newValue;}),
                          items: AreaUnit.getAreaUnits()
                        ), 
                        Separator(height: 0.01),
                        CosechaTextFormField(
                          validator: "El campo Área no puede ser vacío",
                          text: "Área en ",
                          controller: this.areaController,
                          unit: this.areaUnit,
                        ),
                        Separator(height: 0.01),
                        CosechaCalendar(
                          updateDate: this.updateDate,
                          controller: this.sowingDateController,
                          selectedDate: this.selectedSowingDate,
                          label: "Fecha de siembra"
                        ),
                        Separator(height: 0.01),
                        CosechaCalendar(
                          updateDate: this.updateDate,
                          controller: this.harvestDateController,
                          selectedDate: this.selectedHarvestDate,
                          label: "Fecha de cosecha"
                        ),
                        SizedBox(height: 20),
                        Container(
                          child: FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () async {
                              this._onPressed();
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
                      ]
                    )
                  )
                ]
              )
            )
          )
        ]
      )
    );
  }
}
