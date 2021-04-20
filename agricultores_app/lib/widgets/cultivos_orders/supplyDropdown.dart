import 'package:agricultores_app/models/supplyModel.dart';
import 'package:agricultores_app/services/supplyService.dart';
import 'package:flutter/material.dart';

class SupplyDropdown extends StatelessWidget {

  SupplyDropdown({this.supplyID, this.updateSupply, this.setDaysToHarvest});

  final supplyID;
  final updateSupply;
  final setDaysToHarvest;
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SupplyService.getSupplies(),
      builder: (context, snapshot) {
        List<Supply> listItems = [];
        if (snapshot.hasData) {
          listItems = snapshot.data;
        }
        Map<int, Supply> mapItems = listItems.asMap();
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
                updateSupply(mapItems[newValue].id);
                if (setDaysToHarvest != null) {
                  setDaysToHarvest(mapItems[newValue].daysToHarvest);
                }
              },
              items: mapItems.entries.map((item) {
                return DropdownMenuItem(
                  child: Text(item.value.name),
                  value: item.key,
                );
              }).toList(),
            ),
          )
        );
      },
    );
  }
}
