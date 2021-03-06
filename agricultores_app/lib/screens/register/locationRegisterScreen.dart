import 'package:agricultores_app/models/district.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/updateUbigeoService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:agricultores_app/widgets/location/districtDropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:agricultores_app/widgets/location/departmentDropdown.dart';
import 'package:agricultores_app/widgets/location/regionDropdown.dart';

class LocationRegisterScreen extends StatefulWidget {
  LocationRegisterScreen({Key key}) : super(key: key);

  @override
  _LocationRegisterScreenState createState() => _LocationRegisterScreenState();
}

class _LocationRegisterScreenState extends State<LocationRegisterScreen> {
  final _formKey = new GlobalKey<FormState>();
  String code;
  List<Region> _regions = [Region(id: 0, name: '')];
  List<District> _districts = [District(id: 0, name: '')];
  int _selectedDepartment;
  int _selectedRegion;
  int _selectedDistrict;
  bool _departmentIsSelected = false;
  bool _regionIsSelected = false;
  double _lat = 0.0;
  double _lon = 0.0;
  bool isLoading = false;
  bool _regionsAreFetched = false;
  bool _districtsAreFetched = false;

  @override
  void initState() {
    super.initState();
    this._getGPSLocation();
  }

  void _clearRegions() {
    setState(() {
      this._regions = [Region(id: 0, name: '')];
      this._selectedRegion = null;
      this._regionsAreFetched = false;
    });
  }

  void _clearDistricts() {
    setState(() {
      this._districts = [District(id: 0, name: '')];
      this._selectedDistrict = null;
      this._districtsAreFetched = false;
    });
  }

  void _handleDepartmentChange(newValue) {
    setState(() {
      _selectedDepartment = newValue;
      _departmentIsSelected = true;
    });
    this._clearRegions();
    this._clearDistricts();
  }

  void _getGPSLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    print(_locationData.latitude);
    print(_locationData.longitude);

    final coordinates = new Coordinates(
      _locationData.latitude,
      _locationData.longitude,
    );

    setState(() {
      this._lat = coordinates.latitude;
      this._lon = coordinates.longitude;
    });
  }

  void _handleRegionChange(newRegion) {
    setState(() {
      this._selectedRegion = newRegion;
      this._regionIsSelected = true;
    });
    this._clearDistricts();
  }

  void _handleDistrictChange(newDistrict) {
    setState(() {
      this._selectedDistrict = newDistrict;
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
        title: Text('Registro'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CosechaLogo(scale: 5.0),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      Form(
                        key: this._formKey,
                        child: Column(
                          children: [
                            DepartmentDropdown(
                              onChanged: this._handleDepartmentChange,
                              selectedDepartment: this._selectedDepartment,
                            ),
                            Separator(height: 0.02),
                            RegionDropdown(
                              onChanged: this._handleRegionChange,
                              selectedDepartment: this._selectedDepartment,
                              selectedRegion: this._selectedRegion,
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
                            Separator(height: 0.02),
                            DistrictDropdown(
                              onChanged: this._handleDistrictChange, 
                              selectedRegion: this._selectedRegion, 
                              selectedDistrict: this._selectedDistrict, 
                              ignoreCondition: !_departmentIsSelected || !_regionIsSelected, 
                              districts: this._districts, 
                              setDistricts: (List<District> newDistricts) {
                                setState(() {
                                  this._districts = newDistricts;
                                  this._districtsAreFetched = true;
                                });
                              },
                              districtsAreFetched: this._districtsAreFetched
                            ),
                            Separator(height: 0.05),
                            CosechaGreenButton(
                              text: 'Siguiente',
                              isLoading: this.isLoading,
                              onPressed: () async {
                                if (this._formKey.currentState.validate()) {
                                  setState(() {
                                    this.isLoading = true;
                                  });
                                  var response = await UpdateUbigeoService.updateUbigeo(
                                      _selectedDistrict.toString(), _lat, _lon);
                                  setState(() {
                                    this.isLoading = false;
                                  });
                                  print(response);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RoleRegisterScreen(),
                                    ),
                                  );
                                } 
                              },
                            )
                          ]
                        )
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
