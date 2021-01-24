import 'package:agricultores_app/services/myProfileService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
                this._appBar(snapshot, true),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._ubicacion(),
                      this._verMapa(),
                      this._contactar(),
                      this._carruselCultivos(),
                      this._carruselCultivos(),
                      this._carruselCultivos(),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                this._appBar(snapshot, false),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._ubicacion(),
                      this._verMapa(),
                      this._contactar(),
                      this._carruselCultivos(),
                      this._carruselCultivos(),
                      this._carruselCultivos(),
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

  Widget _appBar(AsyncSnapshot snapshot, bool fromUrl) {
    return SliverAppBar(
      floating: true,
      snap: true,
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
        title: fromUrl ? Text(snapshot.data.firstName) : Text("Nombre"),
        collapseMode: CollapseMode.pin,
        background: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            this._profilePicture(snapshot, fromUrl),
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

  Widget _profilePicture(AsyncSnapshot snapshot, bool fromURL) {
    if (fromURL) {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.only(bottom: 70),
        child: CircleAvatar(
          backgroundImage: NetworkImage(snapshot.data.profilePicture),
        ),
      );
    } else {
      return Container(
        height: 150,
        width: 150,
        margin: EdgeInsets.only(bottom: 70),
        child: CircleAvatar(
          backgroundImage: AssetImage('assets/images/user-placeholder.png'),
        ),
      );
    }
  }

  Widget _ubicacion() {
    return Column(
      children: [
        Icon(
          Icons.location_on_outlined,
          color: Colors.indigo[900],
          size: 50,
        ),
        Text("Me encuentras en"),
        Container(
          width: 250,
          height: 50,
          margin: EdgeInsets.only(bottom: 20, top: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(60),
            ),
            color: Colors.blue[50],
          ),
          child: Center(
            child: Text("Sayan, Huara (Lima)"),
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

  Widget _carruselCultivos() {
    return Stack(
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          child: Image(
            image: AssetImage("assets/images/papas.jpg"),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.green),
              ),
              onPressed: () {
                print("Hello");
              },
              color: Colors.green,
              textColor: Colors.white,
              child: Text(
                "Ver todos los cultivos".toUpperCase(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
