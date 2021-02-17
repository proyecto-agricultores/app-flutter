import 'package:agricultores_app/models/menuItems.dart';
import 'package:agricultores_app/screens/buscadorAgricultoresScreen.dart';
import 'package:agricultores_app/screens/buscadorCompradoresScreen.dart';
import 'package:agricultores_app/screens/loginScreen.dart';
import 'package:agricultores_app/screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GridDashboard extends StatelessWidget {
  _getRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final role = await prefs.get('role');
    return role;
  }

  MenuItems item1 = new MenuItems(
    title: "Mi Perfil",
    img: "assets/images/menu/user.png",
    route: "profile",
  );
  MenuItems item2 = new MenuItems(
    title: "Agricultores",
    img: "assets/images/menu/user.png",
    route: "buscadorAgricultores",
  );
  MenuItems item3 = new MenuItems(
    title: "Compradores",
    img: "assets/images/menu/user.png",
    route: "buscadorCompradores",
  );
  MenuItems item4 = new MenuItems(
    title: "Logout",
    img: "assets/images/menu/user.png",
    route: "loginScreen",
  );

  @override
  Widget build(BuildContext context) {
    List<MenuItems> myList = [item1, item2, item3, item4];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
          childAspectRatio: 1.0,
          padding: EdgeInsets.only(left: 16, right: 16),
          crossAxisCount: 2,
          crossAxisSpacing: 18,
          mainAxisSpacing: 18,
          children: myList.map((data) {
            return GestureDetector(
              onTap: () async {
                final role = await this._getRole();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    if (data.route == "profile") {
                      return ProfileScreen(role: role);
                    } else if (data.route == "buscadorAgricultores") {
                      return buscadorAgricultoresScreen(role: role);
                    } else if (data.route == "buscadorCompradores") {
                      return BuscadorCompradoresScreen(role: role);
                    } else if (data.route == "loginScreen") {
                      return LoginScreen();
                    }
                  }),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 102, 0, 1).withAlpha(200),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      data.img,
                      width: 42,
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    Text(
                      data.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFFFFFFFF).withAlpha(200),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            );
          }).toList()),
    );
  }
}
