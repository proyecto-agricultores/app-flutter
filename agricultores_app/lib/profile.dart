import 'package:flutter/material.dart';


class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}




class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            title: Text("Claro pe mascota"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
        Container(
          height: 150,
          width: 150,
          margin: EdgeInsets.only(

          ),
          child: CircleAvatar(
            //
            backgroundImage: NetworkImage('https://pbs.twimg.com/profile_images/1316582251149307905/awdrd8_0_400x400.jpg'),
          ),
        ),
        Text("Me encuentras en"),
        Text("Lugar"),
        Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () {},
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("Ver en  mapa".toUpperCase(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    ),
                  ],
                )  ,
        Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () {},
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("Contactar",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ),
                  ],
                )  ,

        Stack(
          children: [

            Container(
                margin: const EdgeInsets.all(15.0),
                child:Image(
                  image: AssetImage("assets/images/papas.jpg"),
                )
            ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Positioned(

                      top: 200,
                    child: Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.green)),
                      onPressed: () {},
                      color: Colors.green,
                      textColor: Colors.white,
                      child: Text("Ver todos los cultivos".toUpperCase(),
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    )
                  )
                  ),
                ),
              ),
          ],
        ),
      ],
    )
      ),);
  }
}