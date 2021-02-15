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
        if (!snapshot.hasData) {
          return Center(
              child:
                  CircularProgressIndicator());
        } else {
          List<Supply> listResponse =
              snapshot.data;
          return DropdownButtonFormField(
            validator: (value) => value == null ? 'Campo requerido' : null,
            value: supplyID,
            icon: Icon(Icons.arrow_downward),
            onChanged: (newValue) {
              updateSupply(newValue);
            },
            items: listResponse.map((item) {
              return DropdownMenuItem(
                child: Text(item.name),
                value: item.id,
              );
            }).toList(),
            decoration: new InputDecoration(
              labelText: "Insumo",
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            ),
          );
        }
      },
    );
  }
}
