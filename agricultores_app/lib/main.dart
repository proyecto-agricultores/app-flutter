import 'package:agricultores_app/app_icons.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Text(
            //   'You have pushed the button this many times:',
            // ),
            // Text(
            //   '$_counter',
            //   style: Theme.of(context).textTheme.headline4,
            // ),
            Image.asset(
              'assets/images/logo.png',
              height: 150,
              width: 150,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                  onPressed: null,
                  //padding: EdgeInsets.all(50.0),
                  child: Column( // Replace with a Row for horizontal icon + text
                    children: <Widget>[
                      Icon(
                        AppIcons.seedling,
                        size: 70,
                        color: Colors.black54,
                      ),
                      Text("Agricultor")
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.person_search,
                        size: 70,
                        color: Colors.black54,
                      ),
                      Text("Comprador")
                    ],
                  ),
                ),
                FlatButton(
                  onPressed: null,
                  child: Column(
                    children: <Widget>[
                      Icon(
                        Icons.ad_units,
                        size: 70,
                        color: Colors.black54,
                      ),
                      Text("Anunciante")
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 300,
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: 'Número de teléfono',
                  prefixIcon: Icon(
                      Icons.smartphone,
                      color: Colors.green,
                  ),
                )
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              width: 300,
              child: TextFormField(
                  decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.green,
                  ),
                )
              )
            ),
            SizedBox(height: 30),
            Text('¿No tienes una cuenta?'),
            new GestureDetector(
              onTap: () {},
              child: new Text(
                "Regístrate aquí",
                style: TextStyle(
                  color: Colors.blue[400],
                ),
              ),
            ),
            SizedBox(height: 30),
            FlatButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              onPressed: () {},
              color: Colors.green[400],
              child: Text(
                'Ingresar',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                )
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
