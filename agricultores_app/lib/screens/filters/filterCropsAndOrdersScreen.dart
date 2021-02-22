import 'package:agricultores_app/widgets/cultivos_orders/supplyDropdown.dart';
import 'package:agricultores_app/widgets/general/divider.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaTextFormField.dart';
import 'package:agricultores_app/widgets/cultivos_orders/cosechaCalendar.dart';
import 'package:agricultores_app/widgets/location/regionDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:agricultores_app/widgets/location/departmentDropdown.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/screens/filters/filterCropsAndOrdersResultsScreen.dart';

class FilterCropsAndOrdersScreen extends StatefulWidget {

  FilterCropsAndOrdersScreen({this.title, this.role});

  final title;
  final String role;

  @override
  _FilterCropsAndOrdersScreenState createState() => _FilterCropsAndOrdersScreenState(title: this.title, role: this.role);
}

class _FilterCropsAndOrdersScreenState extends State<FilterCropsAndOrdersScreen> {

  _FilterCropsAndOrdersScreenState({this.title, this.role});

  final title;
  final String role;
  final minPriceController = TextEditingController();
  final maxPriceController = TextEditingController();
  final minHarvestDateController = TextEditingController();
  final maxHarvestDateController = TextEditingController();

  int _departmentID;
  int _regionID;
  int _supplyID;
  bool _departmentIsSelected = false;
  List<Region> _regions = [Region(id: 0, name: '')];
  DateTime _selectedMinHarvestDate = DateTime.now();
  DateTime _selectedMaxHarvestDate = DateTime.now();
  bool _regionsAreFetched = false;
  bool _loadingRequest = false;

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
    });
    this._departmentIsSelected = true;
  }

  void _handleRegionChange(newValue) {
    setState(() {
      _regionID = newValue;
    }); 
  }

  updateDate(DateTime picked, TextEditingController dateController) {
    setState(() {
        var date = "${picked.toLocal().year}-${picked.toLocal().month}-${picked.toLocal().day}";
        dateController.text = date;
      },
    );
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
                  SupplyDropdown(
                    supplyID: this._supplyID,
                    updateSupply: this.updateSupplyID,
                  ),
                  CosechaDivider(),
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
                  CosechaTextFormField(
                    validator: "",
                    text: 'Precio mínimo x ',
                    controller: this.minPriceController,
                    unit: 'kg'
                  ),
                  Separator(height: 0.03),
                  CosechaTextFormField(
                    validator: "",
                    text: 'Precio máximo x ',
                    controller: this.maxPriceController,
                    unit: 'kg'
                  ),
                  Separator(height: 0.03),
                  CosechaCalendar(
                    updateDate: this.updateDate,
                    controller: this.minHarvestDateController,
                    selectedDate: this._selectedMinHarvestDate,
                    label: "Fecha mínima de cosecha"
                  ),
                  CosechaCalendar(
                    updateDate: this.updateDate,
                    controller: this.maxHarvestDateController,
                    selectedDate: this._selectedMaxHarvestDate,
                    label: "Fecha máxima de cosecha"
                  ),
                  Separator(height: 0.03),
                  Text('Nota: Todos los campos son opcionales'),
                  Separator(height: 0.03),
                  CosechaGreenButton(
                    isLoading: this._loadingRequest,
                    text: 'Buscar',
                    onPressed: () async {
                      try {
                        setState(() {
                          this._loadingRequest = true;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FilterCropsAndOrdersResultsScreen(
                              title: this.widget.role == 'ag' ? 'Cultivos encontrados' : 'Órdenes encontradas',
                              supplyID: this._supplyID,
                              departmentID: this._departmentID,
                              regionID: this._regionID,
                              minPrice: this.minPriceController.text,
                              maxPrice: this.maxPriceController.text,
                              minDate: this.minHarvestDateController.text,
                              maxDate: this.maxHarvestDateController.text,
                              role: this.widget.role,
                            )
                          )
                        );
                        setState(() {
                          this._loadingRequest = false;
                        });
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
                        this.minPriceController.clear();
                        this.maxPriceController.clear();
                        this.minHarvestDateController.clear();
                        this.maxHarvestDateController.clear();
                        this._selectedMinHarvestDate = this._selectedMaxHarvestDate = DateTime.now();
                      });
                    }
                  )
                ],
              )
            )
          )
        ]
      )
    );
  }
}
