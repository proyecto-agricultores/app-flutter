import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/crearCutivoScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivoAndOrderScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/orders/createOrderScreen.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class TodosCultivosAndOrdersScreen extends StatefulWidget {
  TodosCultivosAndOrdersScreen({Key key, this.title, this.role})
      : super(key: key);

  final String title;
  final String role;

  @override
  _TodosCultivosAndOrdersScreenState createState() =>
      _TodosCultivosAndOrdersScreenState(role: role);
}

class _TodosCultivosAndOrdersScreenState
    extends State<TodosCultivosAndOrdersScreen> {
  _TodosCultivosAndOrdersScreenState({this.role});

  final role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: this.role == 'ag'
            ? Text("Todos mis Cultivos")
            : Text("Todas mis Ordenes"),
      ),
      body: FutureBuilder(
        future: MyProfileService.getLoggedinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  this._carruselCultivos(false),
                  this._agregarCultivoUOrden()
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  this._carruselCultivos(true),
                  this._agregarCultivoUOrden()
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _agregarCultivoUOrden() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
                //builder: (context) => this.role == 'ag' ? CrearCultivoScreen() : CreateOrderScreen(),
                builder: (context) {
              if (this.role == 'ag') {
                return CrearCultivoScreen();
              } else {
                return CreateOrderScreen();
              }
            }),
          );
        },
        color: Colors.green[900],
        textColor: Colors.white,
        child:
            this.role == 'ag' ? Text("Añadir Cultivo") : Text("Añadir Orden"),
      ),
    );
  }

  Widget _carruselCultivos(bool isLoading) {
    if (!isLoading) {
      return FutureBuilder(
        future: this.role == 'ag'
            ? MyPubService.getPubinUser()
            : MyOrderService.getOrdersFromUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final listResponse = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Icon(
                    Icons.agriculture_outlined,
                    color: Colors.indigo[900],
                    size: 50,
                  ),
                  Text(
                    this.role == 'ag' ? 'Mis Cultivos' : 'Mis Ordenes',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CultivoAndOrderScreen(
                                      cultivoId: listResponse[index].id,
                                      titulo: listResponse[index].supplieName,
                                      role: this.role,
                                      isMyCultivoOrOrder: true,
                                      invertRole: false,
                                    ),
                                  ),
                                )
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      image: this.role == 'ag'
                                          ? (listResponse[index]
                                                  .pictureURLs
                                                  .isEmpty
                                              ? AssetImage(
                                                  "assets/images/papas.jpg")
                                              : NetworkImage(listResponse[index]
                                                  .pictureURLs[0]))
                                          : AssetImage(
                                              "assets/images/order.jpg"),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text("Producto: "),
                                      Text(
                                        listResponse[index].supplieName,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Área: '),
                                      Text(listResponse[index].area.toString()),
                                      Text(' '),
                                      Text(listResponse[index].areaUnit),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Costo: '),
                                      Text(listResponse[index]
                                          .unitPrice
                                          .toString()),
                                      Text(' x '),
                                      Text(listResponse[index].weightUnit),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: listResponse.length,
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
            }
          } else {
            return this._shimerPub();
          }
        },
      );
    } else {
      return this._shimerPub();
    }
  }

  Widget _shimerPub() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withAlpha(10),
      highlightColor: Colors.grey.withAlpha(60),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 150,
            color: Colors.white,
          ),
          Row(
            children: [Text("Producto: ")],
          ),
          Row(
            children: [
              Text('Área: '),
            ],
          ),
          Row(
            children: [
              Text('Costo: '),
            ],
          ),
        ],
      ),
    );
  }
}
