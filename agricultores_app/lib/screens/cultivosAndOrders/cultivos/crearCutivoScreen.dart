import 'dart:io';
import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaForm.dart';
import 'package:agricultores_app/widgets/cultivos_orders/imageCarouselWidget.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
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
  int supplyID;

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final _formKey = new GlobalKey<FormState>();

  updateDate(DateTime picked, TextEditingController dateController) {
    setState(
      () {
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
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

  _onPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        this.isLoading = true;
      });
      try {
        final crearCultivoResponse = await MyPubService.create(
          supplyID,
          MyPub(
            // weightUnit: null,
            // unitPrice: null,
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
          await MyPubService.appendPubPicture(
              crearCultivoResponse.id, image.path);
        }

        setState(() {
          this.isLoading = false;
        });
        return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Cultivo creado correctamente.'),
              content: Text(
                  'Se acaba de crear el cultivo. Ahora lo podrás encontrar en tu perfil.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK!'),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } catch (e) {
        print(e.toString());
        throw e;
      }
    }
  }

  updateSupply(newValue) {
    setState(() {
      this.supplyID = newValue;
    });
  }

  updateWeightUnit(newValue) {
    setState(() {
      this.weightUnit = newValue;
    });
  }

  updateAreaUnit(newValue) {
    setState(() {
      this.areaUnit = newValue;
    });
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
        body: Column(children: [
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
                        SizedBox(height: 20),
                        ImageCarousel(
                            images: this._images, getImage: this.getImage),
                        CosechaDivider(),
                        CosechaForm(
                          supplyID: this.supplyID,
                          updateSupply: this.updateSupply,
                          unitPriceController: this.unitPriceController,
                          weightUnit: this.weightUnit,
                          updateWeightUnit: this.updateWeightUnit,
                          areaController: this.areaController,
                          areaUnit: this.areaUnit,
                          updateAreaUnit: this.updateAreaUnit,
                          updateDate: this.updateDate,
                          sowingDateController: this.sowingDateController,
                          selectedSowingDate: this.selectedSowingDate,
                          harvestDateController: this.harvestDateController,
                          selectedHarvestDate: this.selectedHarvestDate,
                          onPressed: this._onPressed,
                          isLoading: this.isLoading,
                          formKey: this._formKey,
                          buttonText: 'Crear Cultivo',
                          hasSupply: true,
                          hasPrice: false,
                          isEditingScreen: false,
                        )
                      ])))
        ]));
  }
}
