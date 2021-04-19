import 'package:agricultores_app/models/colorsModel.dart';
import 'package:agricultores_app/services/adsAdminService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shimmer/shimmer.dart';

class AdsScreen extends StatefulWidget {
  AdsScreen({Key key}) : super(key: key);

  @override
  _AdsScreenState createState() => _AdsScreenState();
}

class _AdsScreenState extends State<AdsScreen> {

  parseLocation(location, labelPlural) {
    return location != false && location != null ? location : labelPlural;
  }

  parseLabel(label, value) {
    return new RichText(
      text: new TextSpan(
        style: new TextStyle(
          fontSize: 14.0,
          color: Colors.black,
          fontFamily: "Poppins",
        ),
        children: <TextSpan>[
          new TextSpan(
            text: label + ": ", 
            style: new TextStyle(fontWeight: FontWeight.bold),
          ),
          new TextSpan(
            text: value,
          )
        ]
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Mis Anuncios"),
        backgroundColor: CosechaColors.azulFuerte,
      ),
      body: Container(
        child: FutureBuilder(
          future: AdsAdminService.getAds(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              final listResponse = snapshot.data;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    CosechaGreenButton(onPressed: () async {
                      const url = 'https://web-platform-advertisement.vercel.app/';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'No se pudo abrir $url';
                      }
                    }, text: "Más información sobre sus anuncios", isLoading: false),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        var adInfo = listResponse[index];
                        return InkWell(
                          child: Column(
                            children: [
                              Text(
                                adInfo.name, 
                                style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10,),
                              Image(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  image: NetworkImage(
                                      adInfo.pictureURL)),
                              SizedBox(height: 10,),
                              parseLabel("Créditos asignados", adInfo.originalCredits.toString()),
                              parseLabel("Créditos restantes", adInfo.remainingCredits.toString()),
                              parseLabel(
                                "Departamento",
                                parseLocation(adInfo.departmentName, "Todos los departamentos."),
                              ),
                              parseLabel(
                                "Región",
                                parseLocation(adInfo.regionName, "Todas las regiones."),
                              ),
                              parseLabel(
                                "Distrito",
                                parseLocation(adInfo.departmentName, "Todos los departamentos."),
                              ),
                              parseLabel("Para órdenes", adInfo.forOrders ? "Sí." : "No."),
                              parseLabel("Para pedidos", adInfo.forOrders ? "Sí." : "No."),
                              parseLabel(
                                "Inicio de siembra", 
                                adInfo.beginningSowingDate == null ? "No asignado." : adInfo.beginningSowingDate
                              ),
                              parseLabel(
                                "Fin de siembra", 
                                adInfo.endingSowingDate == null ? "No asignado." : adInfo.endingSowingDate
                              ),
                              parseLabel(
                                "Inicio de cosecha", 
                                adInfo.beginningHarvestDate == null ? "No asignado." : adInfo.beginningHarvestDate
                              ),
                              parseLabel(
                                "Fin de cosecha", 
                                adInfo.endingHarvestDate == null ? "No asignado." : adInfo.endingHarvestDate
                              ),
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
                      shrinkWrap: true,
                    )
                  ],
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
