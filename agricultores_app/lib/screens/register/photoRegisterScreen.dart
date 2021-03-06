import 'dart:io';

import 'package:agricultores_app/services/uploadProfilePictureService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;

import 'locationRegisterScreen.dart';

class PhotoRegisterScreen extends StatefulWidget {
  PhotoRegisterScreen({
    Key key,
    this.returnToProfile = false,
  }) : super(key: key);

  final bool returnToProfile;

  @override
  _PhotoRegisterScreenState createState() =>
      _PhotoRegisterScreenState(returnToProfile: returnToProfile);
}

class _PhotoRegisterScreenState extends State<PhotoRegisterScreen> {
  _PhotoRegisterScreenState({this.returnToProfile = false});
  var returnToProfile;

  File _image;
  final picker = ImagePicker();
  bool isLoading = false;

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
        title: Text(
          this.returnToProfile ? 'Cambiar foto de perfil' : 'Registro',
        ),
        automaticallyImplyLeading: this.returnToProfile,
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
                            heroTag: 'camera',
                          ),
                          SizedBox(width: 10),
                          FloatingActionButton(
                            onPressed: () => getImage(ImageSource.gallery),
                            tooltip: 'Pick Image From Library',
                            child: Icon(Icons.photo_library),
                            heroTag: 'library',
                          )
                        ],
                      ),
                      SizedBox(height: 40),
                      CosechaGreenButton(
                        onPressed: () async {
                          setState(() {
                            this.isLoading = true;
                          });
                          try {
                            var response = await UploadProfilePictureService
                                .uploadProfilePicture(_image.path);
                            print(response);
                            !this.returnToProfile
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LocationRegisterScreen(),
                                    ),
                                  )
                                : Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                          } catch (e) {
                            print(e);
                          }
                          setState(() {
                            this.isLoading = false;
                          });
                        },
                        text: this.returnToProfile ? 'Guardar' : 'Siguiente',
                        isLoading: this.isLoading,
                      ),
                      !this.returnToProfile
                          ? CosechaGreenButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LocationRegisterScreen(),
                                    ));
                              },
                              text: 'Continuar sin foto',
                              isLoading: false,
                            )
                          : Container(),
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
