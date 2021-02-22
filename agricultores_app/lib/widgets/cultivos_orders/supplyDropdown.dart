import 'package:agricultores_app/models/supplyModel.dart';
import 'package:agricultores_app/services/supplyService.dart';
import 'package:flutter/material.dart';

class SupplyDropdown extends StatelessWidget {

  SupplyDropdown({this.supplyID, this.updateSupply});

  final supplyID;
  final updateSupply;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SupplyService.getSupplies(),
      builder: (context, snapshot) {
        List<Supply> listItems = [];
        if (snapshot.hasData) {
          listItems = snapshot.data;
        } 
        return IgnorePointer(
          ignoring: !snapshot.hasData,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.width * 0.8,
            child: DropdownButtonFormField(
              validator: (value) => value == null ? 'Campo requerido' : null,
              hint: Text(snapshot.hasData ? 'Seleccione un insumo' : 'Cargando...'),
              value: supplyID,
              isExpanded: true,
              onChanged: (newValue) {
                updateSupply(newValue);
              },
              items: listItems.map((item) {
                return DropdownMenuItem(
                  child: Text(item.name),
                  value: item.id,
                );
              }).toList(),
            ),
          )
        );
      },
    );
  }
}
