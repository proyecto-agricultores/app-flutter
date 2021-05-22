import 'package:agricultores_app/models/userModel.dart';
import 'package:agricultores_app/screens/userProfileScreen.dart';
import 'package:agricultores_app/services/adService.dart';
import 'package:agricultores_app/services/userService.dart';
import 'package:agricultores_app/widgets/general/cosechaGreenButton.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Ad extends StatelessWidget {
  Ad({
    @required this.snapshot,
    @required this.roleActual,
  });

  final snapshot;
  final roleActual;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future:
          AdService.getAdForIt(snapshot.data.id, roleActual ? 'pub' : 'order'),
      builder: (BuildContext context, AsyncSnapshot snapshotAd) {
        if (snapshotAd.hasData && snapshotAd.data.displayAdd) {
          return Center(
            child: InkWell(
              onTap: () async {
                if (await canLaunch(snapshotAd.data.targetUrl)) {
                  await launch(snapshotAd.data.targetUrl);
                } else {
                  throw 'Could not launch $snapshotAd.data.targetUrl';
                }
              },
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    width: 1.0,
                    color: Colors.grey.withAlpha(60),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 150.0,
                            child: Container(
                                child: Image.network(snapshotAd.data.imageUrl)),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Text(
                              "  AD  ",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      CosechaGreenButton(
                        text: 'Contactarse con el anunciante',
                        onPressed: () async {
                          String url = 'tel:' + snapshotAd.data.phoneNumber;
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        isLoading: false,
                      ),
                      CosechaGreenButton(
                        text: 'Ver el perfil del anunciante',
                        onPressed: () async {
                          User infoUser = await UserService.getUser(
                              snapshotAd.data.idAdvertiser);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserProfileScreen(
                                id: infoUser.id,
                                firstName: infoUser.firstName,
                                lastName: infoUser.lastName,
                                role: infoUser.role,
                                profilePicture: infoUser.profilePicture,
                                ubigeo: infoUser.ubigeo,
                                phoneNumber: infoUser.phoneNumber,
                                latitude: infoUser.latitude,
                                longitude: infoUser.longitude,
                              ),
                            ),
                          );
                        },
                        isLoading: false,
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (!snapshotAd.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
