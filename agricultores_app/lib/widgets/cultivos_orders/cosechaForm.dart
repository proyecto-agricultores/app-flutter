import 'package:agricultores_app/models/areaUnitModel.dart';
import 'package:agricultores_app/models/priceUnitModel.dart';
import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/widgets/cultivos_orders/unitDropdown.dart';
import 'package:agricultores_app/widgets/general/cancelButton.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:flutter/material.dart';

import 'cosechaCalendar.dart';
import 'cosechaTextFormField.dart';

class CosechaForm extends StatelessWidget {
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
  @override
  Widget build(BuildContext context) {
    return Form(
        key: formKey,
        child: Column(children: [
          this.hasSupply
              ? SupplyDropdown(
                  supplyID: this.supplyID, updateSupply: updateSupply)
              : Container(),
          Separator(height: 0.01),
          this.hasPrice 
          ? Column(
            children: [
              CosechaTextFormField(
                validator: "El campo Precio no puede ser vacío",
                text: "Precio unitario x ",
                controller: this.unitPriceController,
                unit: this.weightUnit,
              ),
              Separator(height: 0.01),
              UnitDropdown(
                initialUnit: this.weightUnit,
                updateUnit: updateWeightUnit,
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
            controller: this.areaController,
            unit: this.areaUnit,
          ),
          UnitDropdown(
            initialUnit: this.areaUnit,
            updateUnit: updateAreaUnit,
            items: AreaUnit.getAreaUnits()
          ), 
          CosechaDivider(),
          Separator(height: 0.01),
          CosechaCalendar(
              updateDate: this.updateDate,
              controller: this.sowingDateController,
              selectedDate: this.selectedSowingDate,
              label: "Fecha de siembra"),
          Separator(height: 0.01),
          CosechaCalendar(
              updateDate: this.updateDate,
              controller: this.harvestDateController,
              selectedDate: this.selectedHarvestDate,
              label: "Fecha de cosecha"),
          SizedBox(height: 20),
          CosechaGreenButton(
            onPressed: this.onPressed,
            text: this.buttonText,
            isLoading: this.isLoading,
          ),
          CancelButton(),
        ]));
  }
}
