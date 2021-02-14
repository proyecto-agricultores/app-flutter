import 'package:agricultores_app/screens/STAB.dart';
import 'package:agricultores_app/screens/cultivos/crearCutivoScreen.dart';
import 'package:agricultores_app/screens/cultivos/cultivoScreen.dart';
import 'package:agricultores_app/screens/orders/createOrderScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/agricultoresFilterService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class buscadorAgricultoresScreen extends StatefulWidget {
  buscadorAgricultoresScreen({Key key, this.title, this.role}) : super(key: key);

  final String title;
  final String role;

  @override
  _buscadorAgricultoresScreenState createState() => _buscadorAgricultoresScreenState(role: role);
}

class _buscadorAgricultoresScreenState extends State<buscadorAgricultoresScreen> {

  _buscadorAgricultoresScreenState({this.role});

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
                      this._carruselUsuarios(false),
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
                      this._carruselUsuarios(true),
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
      backgroundColor: this.role == 'ag' ? Color(0xff09B44D) : Color(0xfffc6e08),
      title: Text("Título"),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.black,
                child: Container(
                  width: 90.0,
                  height: 20.0,
                  color: Colors.black,
                ),
              )
            : SABT(
                child: snapshot.data.firstName != null
                    ? Text(snapshot.data.firstName)
                    : Text("Sin Nombre"),
              ),
        collapseMode: CollapseMode.pin,
        centerTitle: true,
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


  Widget _carruselUsuarios(bool isLoading) {
    if (!isLoading) {
      return FutureBuilder(
        future: agricultoresFilterService.getAgricultores(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final listResponse = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                children: [
                  Icon(
                    Icons.supervised_user_circle_rounded,
                    color: Colors.indigo[900],
                    size: 50,
                  ),
                  Text(
                    'Usuarios',
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
                                    builder: (context) => CultivoScreen(
                                      cultivoId: listResponse[index].id,
                                      titulo: listResponse[index].supplieName,
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
                                      image: listResponse[index].pictureURLs ==
                                              null
                                          ? AssetImage(
                                              "assets/images/papas.jpg")
                                          : NetworkImage(
                                              listResponse[index].pictureURL),
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
      baseColor: Colors.black12,
      highlightColor: Colors.black,
      child: Column(
        children: [
          Container(
            height: 150,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
