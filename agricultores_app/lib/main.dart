import 'package:agricultores_app/services/authService.dart';
import 'package:agricultores_app/services/helloWorldService.dart';
import 'package:agricultores_app/services/token.dart';
import 'package:agricultores_app/app_icons.dart';
import 'package:agricultores_app/screens/loginScreen.dart';
import 'package:flutter/material.dart';

import 'MyColors.dart';

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
        primaryColor: MyColors.getColorsFromHex(0xFF09B44D),
        accentColor: MyColors.getColorsFromHex(0xFF093AC3),
        primarySwatch: Colors.blue,
        fontFamily: 'Poppins',
      ),
      home: LoginScreen(),  
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
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          try {
            final refreshToken = await Token.getToken(TokenType.refresh);
            final tokenGenerator = await AuthenticateService.refresh(refreshToken);

            await Token.setToken(TokenType.access, tokenGenerator.access);
            await Token.setToken(TokenType.refresh, tokenGenerator.refresh);

            final hw = await HelloWorldService.getHelloWorld();
            print(hw.toString());
          } 
          catch(e) {
            print(e.toString());
            final tokenGenerator = await AuthenticateService.authenticate('+51969999869', '1112');
            await Token.setToken(TokenType.access, tokenGenerator.access);
            await Token.setToken(TokenType.refresh, tokenGenerator.refresh);

            final access = await Token.getToken(TokenType.access);
            final refresh = await Token.getToken(TokenType.refresh);

            print(access);
            print(refresh);

            final hw = await HelloWorldService.getHelloWorld();
            print(hw.toString());
          }

        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

// primero, probar el refresh. api/token/refresh
// sino funciona el refresh, es decir, 401 Unauthorized, usar api/token/
// sino funciona api/token/, usuario debe revisar usuario y contraseña (mostrar login)