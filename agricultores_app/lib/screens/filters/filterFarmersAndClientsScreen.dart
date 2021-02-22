import 'package:agricultores_app/widgets/location/regionDropdown.dart';
import 'package:flutter/material.dart';
import 'package:agricultores_app/widgets/location/departmentDropdown.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:flutter/services.dart';
import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/screens/filters/filterFarmersAndClientsResultsScreen.dart';

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
  bool _regionsAreFetched = false;
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
      this._regions = [Region(id: 0, name: '')];
      this._regionID = null;
      this._regionsAreFetched = false;
    });
  }


  void _handleRegionChange(newValue) {
    setState(() {
      _regionID = newValue;
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
        title: Text(this.title),
        backgroundColor: this.role == 'ag' ? Color(0xff09B44D) : Color(0xfffc6e08),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: Column(
                children: [
                  Separator(height: 0.03),
                  SupplyDropdown(
                    supplyID: this._supplyID,
                    updateSupply: this.updateSupplyID,
                  ),
                  DepartmentDropdown(
                    onChanged: this._handleDepartmentChange,
                    selectedDepartment: this._departmentID,
                  ),
                  RegionDropdown(
                    onChanged: this._handleRegionChange,
                    selectedDepartment: this._departmentID,
                    selectedRegion: this._regionID,
                    ignoreCondition: !this._departmentIsSelected,
                    regions: this._regions,
                    setRegions: (List<Region> newRegions) {
                      setState(() {
                        this._regions = newRegions;
                        this._regionsAreFetched = true;
                      });
                    },
                    regionsAreFetched: this._regionsAreFetched,
                  ),
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
