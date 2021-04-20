import 'package:agricultores_app/models/myOrderModel.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaForm.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class UpdateOrderScreen extends StatefulWidget {
  UpdateOrderScreen({
    Key key,
    @required this.ordenId, 
    @required this.titulo, 
    @required this.dataOrden
    }) : super(key: key);

  final int ordenId;
  final String titulo;
  final dataOrden;

  @override
  _UpdateOrderScreenState createState() => _UpdateOrderScreenState(ordenId, titulo, dataOrden);
}

class _UpdateOrderScreenState extends State<UpdateOrderScreen> {

  _UpdateOrderScreenState(
    this.ordenId,
    this.titulo,
    this.dataOrden,
  );

  final int ordenId;
  final String titulo;
  final dataOrden;

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
    setState(() {
        var date = "${picked.toLocal().day}-${picked.toLocal().month}-${picked.toLocal().year}";
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
        final update =
            await MyOrderService.update(
          MyOrder(
            id: this.ordenId,
            supplieName: null,
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
                  'Se acaba de actualizar la orden con nuevos datos.'),
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
  }

  @override
  void initState() {
    super.initState();
    weightUnit = dataOrden.weightUnit;
    unitPriceController.text = dataOrden.unitPrice != null ? dataOrden.unitPrice.toString() : "";
    areaUnit = dataOrden.areaUnit;
    areaController.text = dataOrden.area.toString();
    harvestDateController.text = formatter.format(dataOrden.harvestDate);
    sowingDateController.text = formatter.format(dataOrden.sowingDate);
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
                    hasPrice: true,
                    isEditingScreen: true,
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