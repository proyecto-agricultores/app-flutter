import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:intl/intl.dart';

class EditarCultivoScreen extends StatefulWidget {
  final int cultivoId;
  final String titulo;

  const EditarCultivoScreen({
    Key key,
    @required this.cultivoId,
    @required this.titulo,
  }) : super(key: key);

  @override
  _EditarCultivoScreenState createState() => _EditarCultivoScreenState(
        cultivoId,
        titulo,
      );
}

class _EditarCultivoScreenState extends State<EditarCultivoScreen> {
  final int cultivoId;
  final String titulo;
  _EditarCultivoScreenState(
    this.cultivoId,
    this.titulo,
  );

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
        title: Text(titulo),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              FutureBuilder(
                future: MyPubService.getPubinUserById(cultivoId),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    // while data is loading:
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    final DateFormat formatter = DateFormat('dd-MM-yyyy');
                    return Container(
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            child: Image(
                              height: 300,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.cover,
                              image: snapshot.data.pictureURL == null
                                  ? AssetImage("assets/images/papas.jpg")
                                  : NetworkImage(snapshot.data.pictureURL),
                            ),
                          ),
                          SizedBox(height: 20),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {},
                            color: Colors.green[400],
                            child: Text(
                              'Guardar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                },
              ),
              // Flexible(
              //   flex: 3,
              //   child: Container(
              //     width: MediaQuery.of(context).size.width * 0.8,
              //     child: Column(
              //       children: [
              //         FlatButton(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(18.0),
              //           ),
              //           onPressed: () {},
              //           color: Colors.green[400],
              //           child: Text('Botton 1',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16,
              //               )),
              //         ),
              //         FlatButton(
              //           shape: RoundedRectangleBorder(
              //             borderRadius: BorderRadius.circular(18.0),
              //           ),
              //           onPressed: () {},
              //           color: Colors.green[400],
              //           child: Text('Botton 2',
              //               style: TextStyle(
              //                 color: Colors.white,
              //                 fontWeight: FontWeight.bold,
              //                 fontSize: 16,
              //               )),
              //         )
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
