import 'package:flutter/material.dart';

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: Text("Claro pe mascota"),
          ),
          body:
            Column(
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
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {},
                      color: Colors.red,
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
                          side: BorderSide(color: Colors.red)),
                      onPressed: () {},
                      color: Colors.red,
                      textColor: Colors.white,
                      child: Text("Contactar",
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal)),
                    ),
                  ],
                )  ,

        Stack(
          children: [
            Container(
              width: 450,
                child:Image(
                  image: AssetImage("assets/images/papas.jpg"),
                )
            ),
              Positioned(
                  top: 175,
                  left: 100,
                child: Container(
                alignment: Alignment.center,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red)),
                  onPressed: () {},
                  color: Colors.red,
                  textColor: Colors.white,
                  child: Text("Ver todos los cultivos".toUpperCase(),
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                )
              )
              ),
          ],
        ),
      ],
    )
      )
    );
  }
}