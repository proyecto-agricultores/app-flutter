import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/editarCutivoScreen.dart';
import 'package:agricultores_app/screens/userProfileScreen.dart';
import 'package:agricultores_app/services/adService.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/services/userFilterService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:intl/intl.dart';

import 'dart:async';

import 'package:url_launcher/url_launcher.dart';

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
  bool isLoading = false;

  _CultivoAndOrderScreenState(
    this.pubOrOrderId,
    this.titulo,
    this.role,
    this.isMyCultivoOrOrder,
    this.invertRole,
  );

  Widget viewProfileButton(int userId) {
    return CosechaGreenButton(
      onPressed: this.isLoading ? null : () async {
        setState(() {
          isLoading = true;
        });
        User user = await UserFilterService.getUserById(userId);
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(
              id: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
              role: user.role,
              profilePicture: user.profilePicture,
              ubigeo: user.ubigeo,
              phoneNumber: user.phoneNumber,
              latitude: user.latitude,
              longitude: user.longitude,
            )
          )
        );
        setState(() {
          isLoading = false;
        });
      },
      text: "Ver perfil",
      isLoading: false,
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
                              snapshot.data.unitPrice.toString() != 'null'
                                  ? Row(
                                      children: [
                                        Text(
                                            snapshot.data.unitPrice.toString()),
                                        Text(' x '),
                                        Text(snapshot.data.weightUnit),
                                      ],
                                    )
                                  : Text('Por asignar')
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
                          !this.isMyCultivoOrOrder ? viewProfileButton(snapshot.data.user) : Container(),
                          this.isMyCultivoOrOrder == true
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(roleActual ? "Vendido: " : "Resulto: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      (roleActual
                                              ? snapshot.data.isSold
                                              : snapshot.data.isSolved)
                                          ? "Si"
                                          : "No",
                                    ),
                                  ],
                                )
                              : Container(),
                          SizedBox(height: 20),
                          this.isMyCultivoOrOrder == true
                              ? Column(
                                  children: [
                                    FlatButton(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(18.0),
                                      ),
                                      color: (roleActual
                                              ? snapshot.data.isSold
                                              : snapshot.data.isSolved)
                                          ? Colors.grey[350]
                                          : Colors.blue[400],
                                      onPressed: () async {
                                        roleActual
                                            ? await MyPubService.changeStatus(
                                                pubOrOrderId,
                                                !snapshot.data.isSold,
                                              )
                                            : await MyOrderService.changeStatus(
                                                pubOrOrderId,
                                                !snapshot.data.isSolved,
                                              );
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      },
                                      child: Text(
                                        (roleActual
                                                ? snapshot.data.isSold
                                                : snapshot.data.isSolved)
                                            ? 'Marcar como NO Resuelto'
                                            : 'Marcar como Resuelto',
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
                              : Container(
                                  child: FutureBuilder(
                                    future: AdService.getAdForIt(
                                        snapshot.data.id,
                                        roleActual ? 'pub' : 'order'),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snapshotAd) {
                                      if (snapshotAd.hasData &&
                                          snapshotAd.data.displayAdd) {
                                        return Center(
                                          child: InkWell(
                                            onTap: () async {
                                              if (await canLaunch(
                                                  snapshotAd.data.targetUrl)) {
                                                await launch(
                                                    snapshotAd.data.targetUrl);
                                              } else {
                                                throw 'Could not launch $snapshotAd.data.targetUrl';
                                              }
                                            },
                                            child: DecoratedBox(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                border: Border.all(
                                                  width: 1.0,
                                                  color:
                                                      Colors.grey.withAlpha(60),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.0)),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  top: 10,
                                                  right: 20,
                                                  left: 20,
                                                ),
                                                child: Stack(children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    height: 150.0,
                                                    child: Container(
                                                        child: Image.network(
                                                            snapshotAd.data
                                                                .imageUrl)),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10.0)),
                                                    ),
                                                    child: Text(
                                                      "  AD  ",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else if (!snapshotAd.hasData) {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    },
                                  ),
                                )
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
