import 'package:agricultores_app/screens/cultivosAndOrders/cultivos/crearCutivoScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/cultivoAndOrderScreen.dart';
import 'package:agricultores_app/screens/cultivosAndOrders/orders/createOrderScreen.dart';
import 'package:agricultores_app/services/myOrderService.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/myPubService.dart';
import 'package:agricultores_app/services/filterService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class FilterCropsAndOrdersResultsScreen extends StatefulWidget {
  FilterCropsAndOrdersResultsScreen({
    Key key, 
    @required this.title, 
    @required this.role,
    @required this.supplyID,
    @required this.departmentID,
    @required this.regionID,
    @required this.minPrice,
    @required this.maxPrice,
    @required this.minDate,
    @required this.maxDate,
  }) : super(key: key);

  final String title;
  final String role;
  final int supplyID;
  final int departmentID;
  final int regionID;
  final String minPrice;
  final String maxPrice;
  final String minDate;
  final String maxDate;

  @override
  _FilterCropsAndOrdersResultsScreenState createState() => _FilterCropsAndOrdersResultsScreenState();
}

class _FilterCropsAndOrdersResultsScreenState extends State<FilterCropsAndOrdersResultsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(this.widget.title),
          backgroundColor: this.widget.role == 'ag' ? Color(0xff09B44D) : Color(0xfffc6e08),
        ),
      body: FutureBuilder(
        future: MyProfileService.getLoggedinUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  this._carruselCultivos(false),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 30),
                  this._carruselCultivos(true),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _carruselCultivos(bool isLoading) {
    if (!isLoading) {
      return FutureBuilder(
        future: FilterService.filterPubsAndOrders(
          this.widget.supplyID,
          this.widget.departmentID,
          this.widget.regionID,
          this.widget.minPrice,
          this.widget.maxPrice,
          this.widget.minDate,
          this.widget.maxDate,
          this.widget.role,
        ),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final listResponse = snapshot.data;
            if (snapshot.hasData) {
              return Column(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () => {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CultivoAndOrderScreen(
                                      cultivoId: listResponse[index].id,
                                      titulo: listResponse[index].supplieName,
                                      role: this.widget.role,
                                      isMyCultivoOrOrder: false,
                                      invertRole: this.widget.role == "ag",
                                    ),
                                  ),
                                )
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    child: Image(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      fit: BoxFit.cover,
                                      image: this.widget.role == 'co'
                                          ? (listResponse[index]
                                                      .pictureURLs
                                                      .length ==
                                                  0
                                              ? AssetImage(
                                                  "assets/images/papas.jpg")
                                              : NetworkImage(listResponse[index]
                                                  .pictureURLs[0]))
                                          : AssetImage(
                                              "assets/images/order.jpg"),
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
                                      Text('Área: '),
                                      Text(listResponse[index].area.toString()),
                                      Text(' '),
                                      Text(listResponse[index].areaUnit),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Costo: '),
                                      Text(listResponse[index]
                                          .unitPrice
                                          .toString()),
                                      Text(' x '),
                                      Text(listResponse[index].weightUnit),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const Divider(),
                          itemCount: listResponse.length,
                          padding: const EdgeInsets.all(8),
                          shrinkWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Container();
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
      baseColor: Colors.grey.withAlpha(10),
      highlightColor: Colors.grey.withAlpha(60),
      child: Column(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            height: 150,
            color: Colors.white,
          ),
          Row(
            children: [Text("Producto: ")],
          ),
          Row(
            children: [
              Text('Área: '),
            ],
          ),
          Row(
            children: [
              Text('Costo: '),
            ],
          ),
        ],
      ),
    );
  }
}
