import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/editarCutivoScreen.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:intl/intl.dart';

import 'orders/editOrderScreen.dart';

class CultivoAndOrderScreen extends StatefulWidget {
  final int cultivoId;
  final String titulo;
  final String role;
  final bool isMyCultivoOrOrder;
  final bool invertRole;

  const CultivoAndOrderScreen({
    Key key,
    @required this.cultivoId,
    @required this.titulo,
    @required this.role,
    @required this.isMyCultivoOrOrder,
    @required this.invertRole,
  }) : super(key: key);

  @override
  _CultivoAndOrderScreenState createState() => _CultivoAndOrderScreenState(
        cultivoId,
        titulo,
        role,
        isMyCultivoOrOrder,
        invertRole,
      );
}

class _CultivoAndOrderScreenState extends State<CultivoAndOrderScreen> {
  final int pubOrOrderId;
  final String titulo;
  final role;
  final bool isMyCultivoOrOrder;
  final bool invertRole;

  _CultivoAndOrderScreenState(
    this.pubOrOrderId,
    this.titulo,
    this.role,
    this.isMyCultivoOrOrder,
    this.invertRole,
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

    bool roleActual = this.role == 'ag' && !invertRole;

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
                future: roleActual
                    ? MyPubService.getPubById(pubOrOrderId)
                    : MyOrderService.getOrderById(pubOrOrderId),
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
                          roleActual
                              ? Container(
                                  child: CarouselSlider(
                                    options: CarouselOptions(
                                      height: 200.0,
                                      viewportFraction: 0.6,
                                      enableInfiniteScroll: false,
                                      enlargeCenterPage: true,
                                    ),
                                    items: snapshot.data.pictureURLs
                                        .map<Widget>((item) => Container(
                                              child: Center(
                                                child: Image.network(
                                                  // item.replaceAll(
                                                  //     'https', 'http'),
                                                  item,
                                                  fit: BoxFit.cover,
                                                  height: 200,
                                                ),
                                              ),
                                            ))
                                        .toList(),
                                  ),
                                )
                              : Container(),
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
                              Text('Área: '),
                              Text(snapshot.data.area.toString()),
                              Text(' '),
                              Text(snapshot.data.areaUnit),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Costo: '),
                              Text(snapshot.data.unitPrice.toString()),
                              Text(' x '),
                              Text(snapshot.data.weightUnit),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  roleActual
                                      ? "Siembra: "
                                      : "Deseada de Siembra: ",
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
                              Text(
                                  roleActual
                                      ? "Cosecha: "
                                      : "Deseada de Cosecha: ",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(
                                formatter.format(snapshot.data.harvestDate),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          this.isMyCultivoOrOrder == true
                              ? Column(
                                  children: [
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      color: Colors.green[400],
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => this.role ==
                                                    'ag'
                                                ? EditarCultivoScreen(
                                                    cultivoId:
                                                        this.pubOrOrderId,
                                                    titulo: this.titulo,
                                                    dataCultivo: snapshot.data,
                                                  )
                                                : UpdateOrderScreen(
                                                    ordenId: this.pubOrOrderId,
                                                    titulo: this.titulo,
                                                    dataOrden: snapshot.data,
                                                  ),
                                          ),
                                        );
                                      },
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
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text('¿Estás seguro?'),
                                              content: Text(
                                                  '¿Estas seguro que deseas eliminar el cultivo? Recuerda que esta acción es permanente.'),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Cancelar'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Eliminar'),
                                                  onPressed: () {
                                                    roleActual
                                                        ? MyPubService.delete(
                                                            this.pubOrOrderId)
                                                        : MyOrderService.delete(
                                                            pubOrOrderId);
                                                    Navigator.of(context)
                                                        .popUntil((route) =>
                                                            route.isFirst);
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      color: Colors.red[700],
                                      child: Text(
                                        'Eliminar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Container()
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
