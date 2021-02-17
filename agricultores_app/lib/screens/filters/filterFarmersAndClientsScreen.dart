import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/location/departmentDropdown.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/loading.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:flutter/services.dart';
import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/screens/filters/filterFarmersAndClientsResultsScreen.dart';
import 'package:agricultores_app/services/locationService.dart';

class FilterFarmersAndClientsScreen extends StatefulWidget {

  FilterFarmersAndClientsScreen({
    @required this.title,
    @required this.role
  });
  
  final title;
  final role;

  _FilterFarmersAndClientsState createState() => _FilterFarmersAndClientsState(title: this.title, role: this.role);

}

class _FilterFarmersAndClientsState extends State<FilterFarmersAndClientsScreen> {

  _FilterFarmersAndClientsState({
    @required this.title,
    @required this.role,
  });

  final title;
  final role;

  int _supplyID;
  int _departmentID;
  int _regionID;
  bool _departmentIsSelected = false;
  bool _fetchingRegions = false;
  bool _loadingRequest = false;
  List<Region> _regions = [Region(id: 0, name: '')];

  updateSupplyID(newValue) {
    setState(() {
      this._supplyID = newValue;
    });
  }

  void _handleDepartmentChange(newValue) {
    setState(() {
      this._departmentID = newValue;
      _departmentIsSelected = true;
      _fetchingRegions = true;
      this._regions = [Region(id: 0, name: '')];
      this._regionID = null;
      this._getRegions();
    });
    this._departmentIsSelected = true;
  }

  Widget _regionsDropdown() {
    return IgnorePointer(
        ignoring: !_departmentIsSelected,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.07,
            width: MediaQuery.of(context).size.height * .8,
            child: DropdownButtonFormField(
              isExpanded: true,
              hint: Text('Seleccione su región'),
              value: _regionID,
              validator: (value) => value == null ? 'Campo requerido' : null,
              onChanged: (newValue) {
                setState(() {
                  _regionID = newValue;
                });
              },
              items: this._regions.map((region) {
                return DropdownMenuItem(
                  child: new Text(
                    region.name,
                    textAlign: TextAlign.center,
                  ),
                  value: region.id,
                );
              }).toList(),
            )
          )
        );
  }

  void _getRegions() async {
    final response =
        await LocationService.getRegionsByDepartment(this._departmentID);
    response.insert(0, Region(id: 0, name: 'Todas las regiones'));
    setState(() {
      this._regions = response;
      this._fetchingRegions = false;
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
      appBar: AppBar(title: Text(this.title),),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                children: [
                  SupplyDropdown(
                    supplyID: this._supplyID,
                    updateSupply: this.updateSupplyID,
                  ),
                  CosechaDivider(),
                  DepartmentDropdown(
                    onChanged: this._handleDepartmentChange
                  ),
                  this._fetchingRegions ? CosechaLoading() : this._regionsDropdown(),
                  Separator(height: 0.03),
                  Text('Nota: Todos los filtros son opcionales'),
                  Separator(height: 0.03),
                  CosechaGreenButton(
                    isLoading: this._loadingRequest,
                    text: 'Buscar',
                    onPressed: () async {
                      try {
                        setState(() {
                          this._loadingRequest = true;
                        });
                        setState(() {
                          this._loadingRequest = false;
                        });
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FilterFarmersAndClientsResultsScreenScreen(
                                title: role == 'ag' ? "Agricultores encontrados" : "Compradores encontrados",
                                supplyID: this._supplyID,
                                departmentID: this._departmentID,
                                regionID: this._regionID,
                                role: this.role,
                              )
                          )
                        );
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                  ),
                  CosechaGreenButton(
                    isLoading: false,
                    text: 'Limpiar filtros',
                    onPressed: () {
                      setState(() {
                        this._supplyID = null;
                        this._departmentID = null;
                        this._regionID = null;
                        this._departmentIsSelected = false;
                        this._regions = [Region(id: 0, name: '')];
                      });
                    }
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
