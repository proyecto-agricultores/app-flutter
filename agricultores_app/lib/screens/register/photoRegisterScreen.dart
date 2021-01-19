import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

class PhotoRegisterScreen extends StatefulWidget {
  PhotoRegisterScreen({Key key}) : super(key: key);

  @override
  _PhotoRegisterScreenState createState() => _PhotoRegisterScreenState();
}

class _PhotoRegisterScreenState extends State<PhotoRegisterScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage(ImageSource src) async {
    final pickedFile = await picker.getImage(source: src);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
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
            Image.asset(
              'assets/images/logo.png',
              scale: MediaQuery.of(context).size.height /
                  MediaQuery.of(context).size.width,
            ),
            Flexible(
                flex: 3,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Center(
                        child: _image == null
                            ? Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: new BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: new AssetImage(
                                        'assets/images/user-placeholder.png'),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(100.0),
                                  ),
                                  border: new Border.all(
                                    color: Colors.black38,
                                    width: 2.0,
                                  ),
                                ),
                              )
                            : Container(
                                width: 200.0,
                                height: 200.0,
                                decoration: new BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                    image: new FileImage(_image),
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: new BorderRadius.all(
                                    new Radius.circular(100.0),
                                  ),
                                  border: new Border.all(
                                    color: Colors.black38,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                            onPressed: () => getImage(ImageSource.camera),
                            tooltip: 'Pick Image',
                            child: Icon(Icons.add_a_photo),
                          ),
                          SizedBox(width: 10),
                          FloatingActionButton(
                            onPressed: () => getImage(ImageSource.gallery),
                            tooltip: 'Pick Image',
                            child: Icon(Icons.photo_library),
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        // onPressed: Token.generateOrRefreshToken(telephone, passwordController.text),
                        onPressed: () {},
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
                )),
          ]))),
    );
  }
}
