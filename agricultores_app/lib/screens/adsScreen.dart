import 'package:agricultores_app/services/adsAdminService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show DeviceOrientation, SystemChrome;
import 'package:shimmer/shimmer.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Anuncios"),
      ),
      body: Container(
        child: FutureBuilder(
          future: AdsAdminService.getAds(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final listResponse = snapshot.data;
              return SingleChildScrollView(
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Column(
                        children: [
                          Image(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              image:
                                  NetworkImage(listResponse[index].pictureURL)),
                          Text(listResponse[index].name),
                          Text(listResponse[index].remainingCredits.toString()),
                          Text(listResponse[index].name),
                          Text(listResponse[index].name),
                          Text(listResponse[index].name),
                          Text(listResponse[index].name),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const Divider(
                    height: 50,
                    thickness: 2,
                    indent: 100,
                    endIndent: 100,
                  ),
                  itemCount: listResponse.length,
                  padding: const EdgeInsets.all(8),
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                ),
              );
            } else if (snapshot.data?.length == 0) {
              return Text("Usted no cuenta con anuncios en su cuenta.");
            } else {
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
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
