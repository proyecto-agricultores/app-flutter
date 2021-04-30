import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/editarCutivoScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/orders/editOrderScreen.dart';
import 'package:agricultores_app/screens/userProfileScreen.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/services/userService.dart';
import 'package:agricultores_app/widgets/ad/ad.dart';
import 'package:agricultores_app/widgets/general/contactButton.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CultivoOrder extends StatelessWidget {
  CultivoOrder({
    @required this.pubOrOrderId,
    @required this.isMyCultivoOrOrder,
    @required this.roleActual,
    @required this.role,
    @required this.titulo,
  });

  final pubOrOrderId;
  final isMyCultivoOrOrder;
  final roleActual;
  final role;
  final titulo;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
                (roleActual && snapshot.data.pictureURLs.length != 0)
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
                              Text(snapshot.data.unitPrice.toString()),
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
                    Text(roleActual ? "Siembra: " : "Deseada de Siembra: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      formatter.format(snapshot.data.sowingDate),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(roleActual ? "Cosecha: " : "Deseada de Cosecha: ",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      formatter.format(snapshot.data.harvestDate),
                    ),
                  ],
                ),
                this.isMyCultivoOrOrder == false
                    ? Column(
                        children: [
                          Divider(),
                          Text(roleActual
                              ? "Contactarse con el vendedor:"
                              : "Contactarse con el credor de esta orden:"),
                          ContactButton(
                              phoneNumber: snapshot.data.userPhoneNumber),
                          RichText(
                            text: TextSpan(
                              text: 'visitar el perfil',
                              style: new TextStyle(color: Colors.indigo[900]),
                              recognizer: new TapGestureRecognizer()
                                ..onTap = () async {
                                  User infoUser = await UserService.getUser(
                                      snapshot.data.userId);

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserProfileScreen(
                                        id: infoUser.id,
                                        firstName: infoUser.firstName,
                                        lastName: infoUser.lastName,
                                        role: infoUser.role,
                                        profilePicture: infoUser.profilePicture,
                                        ubigeo: infoUser.ubigeo,
                                        phoneNumber: infoUser.phoneNumber,
                                        latitude: infoUser.latitude,
                                        longitude: infoUser.longitude,
                                      ),
                                    ),
                                  );
                                },
                            ),
                          ),
                          Divider(),
                        ],
                      )
                    : Container(),
                this.isMyCultivoOrOrder == true
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(roleActual ? "Vendido: " : "Resulto: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
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
                              borderRadius: BorderRadius.circular(18.0),
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
                                  ? 'Marcar como NO Vendido'
                                  : 'Marcar como Vendido',
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
                            color: Colors.green[400],
                            onPressed: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => this.role == 'ag'
                                      ? EditarCultivoScreen(
                                          cultivoId: this.pubOrOrderId,
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
                              borderRadius: BorderRadius.circular(18.0),
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
                                          Navigator.of(context).popUntil(
                                              (route) => route.isFirst);
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
                    : Ad(
                        snapshot: snapshot,
                        roleActual: roleActual,
                      ),
              ],
            ),
          );
        }
      },
    );
  }
}
