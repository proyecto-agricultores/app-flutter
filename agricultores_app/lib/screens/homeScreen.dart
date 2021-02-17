//import 'package:agricultores_app/screens/filters/filterCropsAndOrdersScreen.dart';
import 'package:agricultores_app/models/menuItems.dart';
import 'package:agricultores_app/screens/register/locationRegisterScreen.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:agricultores_app/widgets/general/cosechaLogo.dart';
import 'package:agricultores_app/widgets/gridDashboardWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = await prefs.get('role');
    return role;
  }

  MenuItems item1 = new MenuItems(
    title: "Calendar",
    img: "assets/calendar.png",
  );

  MenuItems item2 = new MenuItems(
    title: "Groceries",
    img: "assets/food.png",
  );

  @override
  Widget build(BuildContext context) {
    List<MenuItems> myList = [item1, item2];
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CosechaLogo(scale: 4.5),
                ],
              ),
            ),
            SizedBox(
              height: 25,
            ),
            GridDashboard(),
            CosechaGreenButton(
              onPressed: () async {
                return Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LocationRegisterScreen()),
                );
              },
              text: 'Cambiar Ubicación y Rol',
              isLoading: false,
            ),
          ],
        ),
      ),
    );
  }
}
