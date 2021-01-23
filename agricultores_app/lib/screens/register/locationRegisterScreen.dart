import 'package:agricultores_app/models/departmentModel.dart';
import 'package:agricultores_app/models/district.dart';
import 'package:agricultores_app/models/regionModel.dart';
import 'package:agricultores_app/screens/homeScreen.dart';
import 'package:agricultores_app/services/locationService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/services/updateUbigeoService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

class LocationRegisterScreen extends StatefulWidget {
  LocationRegisterScreen({Key key}) : super(key: key);

  @override
  _LocationRegisterScreenState createState() => _LocationRegisterScreenState();
}

class _LocationRegisterScreenState extends State<LocationRegisterScreen> {
  String code;
  List<Department> _departments;
  List<Region> _regions = [Region(id: 0, name: '')];
  List<District> _districts = [District(id: 0, name: '')];
  int _selectedDepartment;
  int _selectedRegion;
  int _selectedDistrict;
  bool _fetchingDepartments = true;
  bool _fetchingRegions = false;
  bool _fetchingDistricts = false;
  bool _departmentIsSelected = false;
  bool _regionIsSelected = false;
  double _lat = 0.0;
  double _lon = 0.0;

  @override
  void initState() {
    super.initState();
    Token.generateOrRefreshToken("+51969999869", "1112");
    this._getDepartments();
    this._getGPSLocation();
  }

  void _getDepartments() async {
    final response = await LocationService.getDepartments();
    setState(() {
      this._departments = response;
      this._fetchingDepartments = false;
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

  Widget _logo() {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
        Image.asset(
          'assets/images/logo.png',
          scale: MediaQuery.of(context).size.height /
              MediaQuery.of(context).size.width,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.05),
      ],
    );
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
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print("${first.toMap()}");

    setState(() {
      this._lat = coordinates.latitude;
      this._lon = coordinates.longitude;
    });
  }

  Widget _departmentDropdown() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.04,
      width: MediaQuery.of(context).size.height * 0.8,
      child: DropdownButton(
        isExpanded: true,
        hint: Text('Seleccione su departamento'),
        value: _selectedDepartment,
        onChanged: (newValue) {
          setState(() {
            _selectedDepartment = newValue;
            _departmentIsSelected = true;
            _fetchingRegions = true;
            this._regions = [Region(id: 0, name: '')];
            this._selectedRegion = null;
            this._districts = [District(id: 0, name: '')];
            this._selectedDistrict = null;
            this._getRegions();
          });
        },
        items: this._departments.map((department) {
          return DropdownMenuItem(
            child: new Text(
              department.name,
              textAlign: TextAlign.center,
            ),
            value: department.id,
          );
        }).toList(),
      ),
    );
  }

  Widget _nextButton() {
    return FlatButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      onPressed: () async {
        var response = await UpdateUbigeoService.updateUbigeo(
            _selectedDistrict.toString(), _lat, _lon);
        print(response);
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      },
      color: Colors.green[400],
      child: Text(
        'Siguiente',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _loading() {
    return Container(
        height: MediaQuery.of(context).size.height * 0.04,
        child: CircularProgressIndicator());
  }

  Widget _regionsDropdown() {
    return IgnorePointer(
        ignoring: !_departmentIsSelected,
        child: Container(
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.height * 0.8,
            child: DropdownButton(
              isExpanded: true,
              hint: Text('Seleccione su región'),
              value: _selectedRegion,
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
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.height * 0.8,
            child: DropdownButton(
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
              this._logo(),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      this._fetchingDepartments
                          ? this._loading()
                          : this._departmentDropdown(),
                      SizedBox(height: 10),
                      this._fetchingRegions
                          ? this._loading()
                          : this._regionsDropdown(),
                      SizedBox(height: 10),
                      this._fetchingDistricts
                          ? this._loading()
                          : this._districtDropdown(),
                      SizedBox(height: 30),
                      this._nextButton(),
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
