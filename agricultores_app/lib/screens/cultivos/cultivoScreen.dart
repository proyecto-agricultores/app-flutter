import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:intl/intl.dart';

class CultivoScreen extends StatefulWidget {
  final int cultivoId;
  final String titulo;

  const CultivoScreen({
    Key key,
    @required this.cultivoId,
    @required this.titulo,
  }) : super(key: key);

  @override
  _CultivoScreenState createState() => _CultivoScreenState(
        cultivoId,
        titulo,
      );
}

class _CultivoScreenState extends State<CultivoScreen> {
  final int cultivoId;
  final String titulo;
  _CultivoScreenState(
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Producto: "),
                              Text(
                                snapshot.data.supplieName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Cantidad: '),
                              Text(
                                snapshot.data.quantity.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data.unit,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Costo: '),
                              Text(snapshot.data.unitPrice.toString()),
                              Text(' x '),
                              Text(snapshot.data.unit),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Siembra: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                formatter.format(snapshot.data.sowingDate),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Cosecha: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                formatter.format(snapshot.data.harvestDate),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {},
                            color: Colors.green[400],
                            child: Text(
                              'Editar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          FlatButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                            onPressed: () {},
                            color: Colors.red[700],
                            child: Text(
                              'Eliminar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          )
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
