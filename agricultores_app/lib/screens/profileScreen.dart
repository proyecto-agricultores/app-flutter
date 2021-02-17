import 'package:agricultores_app/screens/STAB.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/crearCutivoScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivoAndOrderScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/orders/createOrderScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/todosCultivosAndOrderScreen.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

import 'cultivosAndOrders/matchesScreen.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.title, this.role}) : super(key: key);

  final String title;
  final String role;

  @override
  _ProfileScreenState createState() => _ProfileScreenState(role: role);
}

class _ProfileScreenState extends State<ProfileScreen> {
  _ProfileScreenState({this.role});

  final role;

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: Drawer(),
      body: FutureBuilder(
        future: MyProfileService.getLoggedinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: [
                this._appBar(snapshot, false),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._ubicacion(snapshot, false),
                      this._verMapa(),
                      this._agregarCultivoUOrden(),
                      this._verMatches(),
                      this._verTodosCultivos(),
                      this._carruselCultivos(false),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                this._appBar(snapshot, true),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._ubicacion(snapshot, true),
                      this._verMapa(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _appBar(AsyncSnapshot snapshot, bool isLoading) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      expandedHeight: 300.0,
      backgroundColor:
          this.role == 'ag' ? Color(0xff09B44D) : Color(0xfffc6e08),
      title: Text("Perfil"),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white.withAlpha(5),
                highlightColor: Colors.white.withAlpha(50),
                child: Container(
                  width: 90.0,
                  height: 20.0,
                  color: Colors.white,
                ),
              )
            : SABT(
                child: snapshot.data.firstName != null
                    ? Text(snapshot.data.firstName)
                    : Text("Sin Nombre"),
              ),
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            this._profilePicture(snapshot, isLoading),
          ],
        ),
      ),
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              child: Column(
                children: [
                  Icon(Icons.person_outlined),
                  Text("Perfil"),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Icon(Icons.coronavirus_outlined),
                  Text("Cultivos"),
                ],
              ),
            ),
            Container(
              child: Column(
                children: [
                  Icon(Icons.person_outlined),
                  Text("Pedidos"),
                ],
              ),
            ),
          ],
        ),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            _scaffoldKey.currentState.openEndDrawer();
          },
        ),
      ],
    );
  }

  Widget _profilePicture(AsyncSnapshot snapshot, bool isLoading) {
    if (isLoading) {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.only(bottom: 70),
        child: Shimmer.fromColors(
          baseColor: Colors.white.withAlpha(5),
          highlightColor: Colors.white.withAlpha(60),
          child: CircleAvatar(),
        ),
      );
    } else if (snapshot.data.profilePicture == null) {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.only(bottom: 70),
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/images/user-placeholder.png"),
        ),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.only(bottom: 70),
        child: CircleAvatar(
          backgroundImage: NetworkImage(snapshot.data.profilePicture),
        ),
      );
    }
  }

  Widget _ubicacion(AsyncSnapshot snapshot, bool isLoading) {
    return Column(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.indigo[900],
          size: 50,
        ),
        Text("Me encuentras en"),
        !isLoading
            ? Container(
                width: 250,
                height: 50,
                margin: EdgeInsets.only(bottom: 20, top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                  color: Colors.blue[50],
                ),
                child: Center(
                    child: snapshot.data.ubigeo != null
                        ? Text(
                            snapshot.data.ubigeo,
                            textAlign: TextAlign.center,
                          )
                        : Text(
                            'Sin Ubicación',
                            textAlign: TextAlign.center,
                          )),
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey.withAlpha(5),
                highlightColor: Colors.grey.withAlpha(60),
                child: Container(
                  width: 250,
                  height: 50,
                  margin: EdgeInsets.only(bottom: 20, top: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(60),
                    ),
                    color: Colors.blue[50],
                  ),
                ),
              ),
      ],
    );
  }

  Widget _verMapa() {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
          side: BorderSide(color: Colors.green),
        ),
        onPressed: () {},
        color: Colors.green,
        textColor: Colors.white,
        child: Text("Ver en mapa"),
      ),
    );
  }

  Widget _verTodosCultivos() {
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
                return TodosCultivosAndOrdersScreen(
                  role: this.role,
                );
              } else {
                return TodosCultivosAndOrdersScreen(
                  role: this.role,
                );
              }
            }),
          );
        },
        color: Colors.green[900],
        textColor: Colors.white,
        child: this.role == 'ag'
            ? Text("Ver todos los Cultivos")
            : Text("Ver todas las Ordenes"),
      ),
    );
  }

  Widget _verMatches() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              if (this.role == 'ag') {
                return MatchesScreen(
                  role: this.role,
                );
              } else {
                return MatchesScreen(
                  role: this.role,
                );
              }
            }),
          );
        },
        color: Colors.green[900],
        textColor: Colors.white,
        child: this.role == 'ag'
            ? Text("Sugerirme ventas")
            : Text("Sugerirme compras"),
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
            ? MyPubService.getFeaturedPubFromUser()
            : MyOrderService.getFeaturedOrdersFromUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final listResponse = snapshot.data;
            if (listResponse.length > 0) {
              return Column(
                children: [
                  Icon(
                    Icons.agriculture_outlined,
                    color: Colors.indigo[900],
                    size: 50,
                  ),
                  Text(
                    this.role == 'ag'
                        ? 'Mis Cultivos Destacados'
                        : 'Mis Ordenes Destacadas',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 24.0),
                      height: MediaQuery.of(context).size.height * 0.45,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
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
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    image: this.role == 'ag'
                                        ? (listResponse[index]
                                                .pictureURLs
                                                .isEmpty
                                            ? AssetImage(
                                                "assets/images/papas.jpg")
                                            : NetworkImage(listResponse[index]
                                                .pictureURLs[0]))
                                        : AssetImage("assets/images/order.jpg"),
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
      baseColor: Colors.grey.withAlpha(5),
      highlightColor: Colors.grey.withAlpha(60),
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.grey.withAlpha(60),
          ),
        ],
      ),
    );
  }
}
