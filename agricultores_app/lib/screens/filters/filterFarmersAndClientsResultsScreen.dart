import 'package:agricultores_app/screens/STAB.dart';
import 'package:agricultores_app/screens/userProfileScreen.dart';
import 'package:agricultores_app/services/myProfileService.dart';
import 'package:agricultores_app/services/filterService.dart';
import 'package:agricultores_app/widgets/shimmer/ShimmerUser.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmer/shimmer.dart';

class FilterFarmersAndClientsResultsScreenScreen extends StatefulWidget {
  FilterFarmersAndClientsResultsScreenScreen(
      {Key key,
      @required this.title,
      @required this.supplyID,
      @required this.departmentID,
      @required this.regionID,
      @required this.role})
      : super(key: key);

  final String title;
  final String role;
  final int supplyID;
  final int departmentID;
  final int regionID;

  @override
  _FilterFarmersAndClientsResultsScreenScreenState createState() =>
      _FilterFarmersAndClientsResultsScreenScreenState(
          title: this.title,
          supplyID: this.supplyID,
          departmentID: this.departmentID,
          regionID: this.regionID,
          role: role);
}

class _FilterFarmersAndClientsResultsScreenScreenState
    extends State<FilterFarmersAndClientsResultsScreenScreen> {
  _FilterFarmersAndClientsResultsScreenScreenState({
    @required this.title,
    @required this.supplyID,
    @required this.departmentID,
    @required this.regionID,
    @required this.role,
  });

  final String title;
  final String role;
  final int supplyID;
  final int departmentID;
  final int regionID;

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
                this._appBar(snapshot, false),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._buscar(),
                      this._carruselUsuarios(false),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return CustomScrollView(
              slivers: [
                this._appBar(snapshot, true),
                SliverToBoxAdapter(
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 30),
                      this._carruselUsuarios(true),
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

  Widget _appBar(AsyncSnapshot snapshot, bool isLoading) {
    return SliverAppBar(
      floating: true,
      snap: true,
      pinned: true,
      expandedHeight: 100.0,
      backgroundColor: Color(this.role == 'co' ? 0xfffc6e08 : 0xff09B44D),
      shape: ContinuousRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(60),
          bottomRight: Radius.circular(60),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        title: isLoading
            ? Shimmer.fromColors(
                baseColor: Colors.white.withAlpha(20),
                highlightColor: Colors.white.withAlpha(60),
                child: Text(
                  this.title,
                  style: TextStyle(fontSize: 12),
                ),
              )
            : SABT(child: Text(this.title, style: TextStyle(fontSize: 12))),
        collapseMode: CollapseMode.pin,
        centerTitle: true,
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

  Widget _carruselUsuarios(bool isLoading) {
    if (!isLoading) {
      return FutureBuilder(
        future: FilterService.filterFarmersAndClients(
            this.supplyID, this.departmentID, this.regionID, this.role),
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
                                    builder: (context) => UserProfileScreen(
                                      id: listResponse[index].id,
                                      firstName: listResponse[index].firstName,
                                      lastName: listResponse[index].lastName,
                                      role: listResponse[index].role,
                                      profilePicture:
                                          listResponse[index].profilePicture,
                                      ubigeo: listResponse[index].ubigeo,
                                      latitude: listResponse[index].latitude,
                                      longitude: listResponse[index].longitude,
                                    ),
                                  ),
                                )
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                            height: 80,
                                            width: 80,
                                            margin: EdgeInsets.only(right: 40),
                                            child: CircleAvatar(
                                                backgroundImage: listResponse[
                                                                index]
                                                            .profilePicture ==
                                                        null
                                                    ? AssetImage(
                                                        "assets/images/user-placeholder.png")
                                                    : NetworkImage(
                                                        listResponse[index]
                                                            .profilePicture))),
                                        Column(children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                (listResponse[index]
                                                                .firstName ==
                                                            null
                                                        ? ""
                                                        : (listResponse[index]
                                                            .firstName)) +
                                                    " " +
                                                    (listResponse[index]
                                                                .lastName ==
                                                            null
                                                        ? ""
                                                        : listResponse[index]
                                                            .lastName),
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                width: 200,
                                                child: Text(
                                                  listResponse[index].ubigeo,
                                                ),
                                              )
                                            ],
                                          )
                                        ])
                                      ])
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
            return ShimmerUser();
          }
        },
      );
    } else {
      return ShimmerUser();
    }
  }

  Widget _buscar() {
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
        child: Text("Nueva búsqueda"),
      ),
    );
  }
}
