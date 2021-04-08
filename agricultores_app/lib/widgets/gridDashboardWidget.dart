import 'package:agricultores_app/models/menuItems.dart';
import 'package:agricultores_app/screens/filters/filterCropsAndOrdersScreen.dart';
import 'package:agricultores_app/screens/filters/filterFarmersAndClientsScreen.dart';
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

  MenuItems perfil = new MenuItems(
    title: "Mi Perfil",
    img: "assets/images/menu/user.png",
    route: "profile",
  );
  MenuItems agricultor = new MenuItems(
    title: "Agricultores",
    img: "assets/images/menu/farmer.png",
    route: "buscadorAgricultores",
  );
  MenuItems comprador = new MenuItems(
    title: "Compradores",
    img: "assets/images/menu/clerk.png",
    route: "buscadorCompradores",
  );
  MenuItems logout = new MenuItems(
    title: "Cerrar Sesión",
    img: "assets/images/menu/logout.png",
    route: "loginScreen",
  );
  MenuItems orden = new MenuItems(
    title: "Órdenes",
    img: "assets/images/menu/shopping-cart.png",
    route: "farmers",
  );
  MenuItems cultivo = new MenuItems(
    title: "Cultivos",
    img: "assets/images/menu/harvest.png",
    route: "crops",
  );

  @override
  Widget build(BuildContext context) {
    List<MenuItems> myList = [
      cultivo,
      orden,
      agricultor,
      comprador,
      perfil,
      logout,
    ];
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
                      return FilterFarmersAndClientsScreen(
                        title: "Buscar agricultores",
                        role: "ag",
                      );
                    } else if (data.route == "buscadorCompradores") {
                      return FilterFarmersAndClientsScreen(
                        title: "Buscar compradores",
                        role: "co",
                      );
                    } else if (data.route == "loginScreen") {
                      return LoginScreen();
                    } else if (data.route == "farmers") {
                      return FilterCropsAndOrdersScreen(
                        title: "Buscar órdenes",
                        role: "co",
                      );
                    } else if (data.route == "crops") {
                      return FilterCropsAndOrdersScreen(
                        title: "Buscar cultivos",
                        role: "ag",
                      );
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
                      height: 20,
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
