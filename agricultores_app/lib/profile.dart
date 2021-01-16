import 'package:flutter/material.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
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
      ),
      extendBodyBehindAppBar: true,
      endDrawer: Drawer(),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 235.0,
              child: const DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(60),
                    bottomRight: Radius.circular(60),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: 150.0),
                SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                        height: 150,
                        width: 150,
                        margin: EdgeInsets.only(bottom: 10),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://pbs.twimg.com/profile_images/1316582251149307905/awdrd8_0_400x400.jpg'),
                        ),
                      ),
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
                      Container(
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
                      ),
                      Container(
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
                      ),
                      Stack(
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
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
