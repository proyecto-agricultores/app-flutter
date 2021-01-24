import 'package:agricultores_app/screens/STAB.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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
                      this._contactar(),
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
                      this._contactar(),
                      this._carruselCultivos(true),
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
      backgroundColor: Colors.indigo,
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
                child: Text(snapshot.data.firstName),
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
          baseColor: Colors.black12,
          highlightColor: Colors.black,
          child: CircleAvatar(),
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
                child: Center(child: Text(snapshot.data.ubigeo)),
              )
            : Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.black,
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

  Widget _contactar() {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        onPressed: () {},
        color: Colors.blue[900],
        textColor: Colors.white,
        child: Text("Contactar"),
      ),
    );
  }

  Widget _carruselCultivos(bool isLoading) {
    if (!isLoading) {
      return FutureBuilder(
        future: MyPubService.getPubinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            // data loaded:
            final listResponse = snapshot.data;
            if (listResponse.isEmpty) {
              return Column(
                children: [
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.green),
                    ),
                    onPressed: () {},
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Text("Crear mi primer cultivo aquí".toUpperCase()),
                  ),
                ],
              );
            } else {
              return Column(
                children: [
                  Icon(
                    Icons.agriculture_outlined,
                    color: Colors.indigo[900],
                    size: 50,
                  ),
                  Text(
                    'Mis Cultivos',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  child: Image(
                                    height: 150,
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit.cover,
                                    image: listResponse[index].pictureURL ==
                                            null
                                        ? AssetImage("assets/images/papas.jpg")
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
                                    Text('Cantidad: '),
                                    Text(
                                      listResponse[index].quantity.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      listResponse[index].unit,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('Costo: '),
                                    Text(listResponse[index]
                                        .unitPrice
                                        .toString()),
                                    Text(' x '),
                                    Text(listResponse[index].unit),
                                  ],
                                ),
                              ],
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: listResponse.length,
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                        )
                      ],
                    ),
                  ),
                ],
              );
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
