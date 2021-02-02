import 'package:agricultores_app/models/myOrderModel.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaForm.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CreateOrderScreen extends StatefulWidget {
  CreateOrderScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CreateOrderScreenState createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {

  bool _isLoading = false;
  final _formKey = new GlobalKey<FormState>();
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
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  updateSupply(newValue) {
    setState(() {
      this.supplyID = newValue;
    });
  }

  updateDate(DateTime picked, TextEditingController dateController) {
    setState(() {
        var date = "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
        dateController.text = date;
      },
    );
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

  _onPressed() async {
    if (_formKey.currentState
        .validate()) {
      setState(() {
        this._isLoading = true;
      });
      try {
        final crearOrdenResponse =
            await MyOrderService.create(
          supplyID,
          MyOrder(
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
          this._isLoading = false;
        });
        return showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder:
              (BuildContext context) {
            return AlertDialog(
              title: Text(
                  'Orden creada correctamente.'),
              content: Text(
                  'Se acaba de crear la orden. Ahora la podrás encontrar en tu perfil.'),
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
        print(e.toString());
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
        title: Text('Crear Orden'),
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
                    isLoading: this._isLoading,
                    formKey: this._formKey,
                    buttonText: 'Crear Orden',
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