import 'package:agricultores_app/models/myPubModel.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaForm.dart';
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
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

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

  updateDate(DateTime picked, TextEditingController dateController) {
    setState(
      () {
        var date =
            "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        dateController.text = date;
      },
    );
  }

  _onPressed() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        this.isLoading = true;
      });
      try {
        final update = await MyPubService.update(
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
              title: Text('Cambios realizados correctamente.'),
              content:
                  Text('Se acaba de actualizar el cultivo con nuevos datos.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK!'),
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
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
                        CosechaForm(
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
                          buttonText: 'Guardar Cambios',
                          hasSupply: false,
                        )
                      ])))
        ]));
  }
}
