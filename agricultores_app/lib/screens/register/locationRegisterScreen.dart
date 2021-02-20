import 'package:agricultores_app/models/district.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/screens/register/roleRegisterScreen.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/services/updateUbigeoService.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:agricultores_app/widgets/general/separator.dart';
import 'package:agricultores_app/widgets/general/loading.dart';
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
  bool _fetchingRegions = false;
  bool _fetchingDistricts = false;
  bool _departmentIsSelected = false;
  bool _regionIsSelected = false;
  double _lat = 0.0;
  double _lon = 0.0;
  bool isLoading = false;
  bool _regionsFetched = false;

  @override
  void initState() {
    super.initState();
    this._getGPSLocation();
  }

  void setRegions(List<Region> newRegions) {
    setState(() {
      this._regions = newRegions;
      this._regionsFetched = true;
    });
  }

  void _handleDepartmentChange(newValue) {
    setState(() {
      _selectedDepartment = newValue;
      _departmentIsSelected = true;
      _fetchingRegions = true;
      this._regions = [Region(id: 0, name: '')];
      this._selectedRegion = null;
      this._regionsFetched = false;
      this._districts = [District(id: 0, name: '')];
      this._selectedDistrict = null;
      this._getRegions();
    });
  }

  void _getRegions() async {
    final response =
        await LocationService.getRegionsByDepartment(this._selectedDepartment);
    setState(() {
      this._regions = response;
      this._fetchingRegions = false;
    });
  }

  void _getDistricts() async {
    final response =
        await LocationService.getDistrictsByRegion(this._selectedRegion);
    setState(() {
      this._districts = response;
      this._fetchingDistricts = false;
    });
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

  Widget _nextButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
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
      color: Colors.green[400],
      child: this.isLoading
          ? LinearProgressIndicator(
              minHeight: 5,
            )
          : Text(
              'Siguiente',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
    );
  }

  Widget _regionsDropdown() {
    return IgnorePointer(
        ignoring: !_departmentIsSelected,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.height * .8,
            child: DropdownButtonFormField(
              isExpanded: true,
              hint: Text('Seleccione su región'),
              value: _selectedRegion,
              validator: (value) => value == null ? 'Campo requerido' : null,
              onChanged: (newValue) {
                setState(() {
                  _selectedRegion = newValue;
                  _regionIsSelected = true;
                  _fetchingDistricts = true;
                  this._districts = [District(id: 0, name: '')];
                  this._selectedDistrict = null;
                  this._getDistricts();
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
            )));
  }

  Widget _districtDropdown() {
    return IgnorePointer(
        ignoring: !_departmentIsSelected || !_regionIsSelected,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.11,
            width: MediaQuery.of(context).size.height * 0.8,
            child: DropdownButtonFormField(
              validator: (value) => value == null ? 'Campo requerido' : null,
              isExpanded: true,
              hint: Text('Seleccione su distrito'),
              value: _selectedDistrict,
              onChanged: (newValue) {
                setState(() {
                  _selectedDistrict = newValue;
                });
              },
              items: this._districts.map((district) {
                return DropdownMenuItem(
                  child: new Text(
                    district.name,
                    textAlign: TextAlign.center,
                  ),
                  value: district.id,
                );
              }).toList(),
            )));
  }

  void _handleRegionChange(newRegion) {
    setState(() {
      this._selectedRegion = newRegion;
      this._regionIsSelected = true;
      this._fetchingDistricts = true;
      this._districts = [District(id: 0, name: '')];
      this._selectedDistrict = null;
      this._getDistricts();
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
                            ),
                            Separator(height: 0.02),
                            // this._fetchingRegions
                            //     ? CosechaLoading()
                            //     : this._regionsDropdown(),
                            RegionDropdown(
                              onChanged: this._handleRegionChange,
                              selectedDepartment: this._selectedDepartment,
                              selectedRegion: this._selectedRegion,
                              ignoreCondition: !this._departmentIsSelected,
                              regions: this._regions,
                              setRegions: this.setRegions,
                              regionsFetched: this._regionsFetched,
                            ),
                            Separator(height: 0.02),
                            this._fetchingDistricts
                                ? CosechaLoading()
                                : this._districtDropdown(),
                            Separator(height: 0.05),
                            this._nextButton(),
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
