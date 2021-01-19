import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';

import 'package:flutter_verification_code/flutter_verification_code.dart';

class LocationRegisterScreen extends StatefulWidget {
  LocationRegisterScreen({Key key}) : super(key: key);

  @override
  _LocationRegisterScreenState createState() => _LocationRegisterScreenState();
}

class _LocationRegisterScreenState extends State<LocationRegisterScreen> {
  String code;
  String _selectedDistrict;
  List<String> _locations = ['A', 'B', 'C', 'D']; // Option 2

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
              //Flexible(
              //child:
              Image.asset(
                'assets/images/logo.png',
                scale: MediaQuery.of(context).size.height /
                    MediaQuery.of(context).size.width,
                //),
              ),
              Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      DropdownButton(
                        hint: Text(
                            'Please choose a location'), // Not necessary for Option 1
                        value: _selectedDistrict,
                        onChanged: (newValue) {
                          setState(() {
                            _selectedDistrict = newValue;
                          });
                        },
                        items: _locations.map((location) {
                          return DropdownMenuItem(
                            child: new Text(location),
                            value: location,
                          );
                        }).toList(),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                        onPressed: () async {
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
                            _permissionGranted =
                                await location.requestPermission();
                            if (_permissionGranted !=
                                PermissionStatus.granted) {
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
                          var addresses = await Geocoder.local
                              .findAddressesFromCoordinates(coordinates);
                          var first = addresses.first;
                          print("${first.toMap()}");
                        },
                        color: Colors.green[400],
                        child: Text('Ubicación GPS',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
                      ),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                        onPressed: () {
                          print(code);
                        },
                        color: Colors.green[400],
                        child: Text('Siguiente',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            )),
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
