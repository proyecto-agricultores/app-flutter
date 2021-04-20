import 'package:agricultores_app/models/areaUnitModel.dart';
import 'package:agricultores_app/models/priceUnitModel.dart';
import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/widgets/cultivos_orders/unitDropdown.dart';
import 'package:agricultores_app/widgets/general/cancelButton.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'cosechaCalendar.dart';
import 'cosechaTextFormField.dart';

class CosechaForm extends StatefulWidget {
  CosechaForm({
    this.supplyID,
    this.updateSupply,
    @required this.unitPriceController,
    @required this.weightUnit,
    @required this.updateWeightUnit,
    @required this.areaController,
    @required this.areaUnit,
    @required this.updateAreaUnit,
    @required this.updateDate,
    @required this.sowingDateController,
    @required this.selectedSowingDate,
    @required this.harvestDateController,
    @required this.selectedHarvestDate,
    @required this.onPressed,
    @required this.isLoading,
    @required this.formKey,
    @required this.buttonText,
    @required this.hasSupply,
    @required this.hasPrice,
    @required this.isEditingScreen
  });

  final supplyID;
  final updateSupply;
  final unitPriceController;
  final weightUnit;
  final updateWeightUnit;
  final areaController;
  final areaUnit;
  final updateAreaUnit;
  final updateDate;
  final sowingDateController;
  final selectedSowingDate;
  final harvestDateController;
  final selectedHarvestDate;
  final onPressed;
  final isLoading;
  final formKey;
  final buttonText;
  final hasSupply;
  final hasPrice;
  final isEditingScreen;

  @override
  _CosechaFormState createState() => _CosechaFormState();

}

class _CosechaFormState extends State<CosechaForm> {

  String suggestedHarvestDate = "-";
  DateTime initialSowingDate;
  int daysToHarvest;

  @override
  void initState() {
    super.initState();
    initialSowingDate = this.widget.selectedSowingDate;
    initializeDateFormatting();
  }

  setSuggestedHarvestDate(int days) {
    setState(() {
      daysToHarvest = days;
    });
  }

  getSuggestedHarvestDate() {
    if (this.widget.sowingDateController.text != "" && daysToHarvest != null) {
      DateTime sowingDate = new DateFormat("dd-MM-yyyy").parse(this.widget.sowingDateController.text);
      DateTime newDate = new DateTime(sowingDate.year, sowingDate.month, sowingDate.day + daysToHarvest);
      return "${newDate.day.toString()}-${newDate.month.toString()}-${newDate.year.toString()}";
    } else {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: this.widget.formKey,
        child: Column(children: [
          this.widget.hasSupply
              ? SupplyDropdown(
                  supplyID: this.widget.supplyID, updateSupply: this.widget.updateSupply, setSuggestedHarvestDate: this.setSuggestedHarvestDate,)
              : Container(),
          Separator(height: 0.01),
          this.widget.hasPrice 
          ? Column(
            children: [
              CosechaTextFormField(
                validator: "El campo Precio no puede ser vacío",
                text: "Precio unitario x ",
                controller: this.widget.unitPriceController,
                unit: this.widget.weightUnit,
              ),
              Separator(height: 0.01),
              UnitDropdown(
                initialUnit: this.widget.weightUnit,
                updateUnit: this.widget.updateWeightUnit,
                items: PriceUnit.getPriceUnits()
              ),
              Separator(height: 0.01),
              CosechaDivider(),
              Separator(height: 0.01),
            ],
          )
          : Container(),
          CosechaTextFormField(
            validator: "El campo Área no puede ser vacío",
            text: "Área en ",
            controller: this.widget.areaController,
            unit: this.widget.areaUnit,
          ),
          UnitDropdown(
            initialUnit: this.widget.areaUnit,
            updateUnit: this.widget.updateAreaUnit,
            items: AreaUnit.getAreaUnits()
          ), 
          CosechaDivider(),
          Separator(height: 0.01),
          CosechaCalendar(
              updateDate: this.widget.updateDate,
              controller: this.widget.sowingDateController,
              selectedDate: this.widget.selectedSowingDate,
              label: "Fecha de siembra"),
          Separator(height: 0.01),
          CosechaCalendar(
              updateDate: this.widget.updateDate,
              controller: this.widget.harvestDateController,
              selectedDate: this.widget.selectedHarvestDate,
              label: "Fecha de cosecha"),
          Text("Fecha de cosecha sugerida: " + getSuggestedHarvestDate()),
          SizedBox(height: 20),
          CosechaGreenButton(
            onPressed: this.widget.onPressed,
            text: this.widget.buttonText,
            isLoading: this.widget.isLoading,
          ),
          CancelButton(),
        ]));
  }
}
